--- highlights.lua
--- A robust helper for setting Neovim highlights programmatically.
---
--- Usage:
---   local hl = require("highlights")
---
---   -- Simple fg/bg
---   hl.set("Normal", { fg = "#cdd6f4", bg = "#1e1e2e" })
---
---   -- Styles
---   hl.set("Comment", { fg = "#6c7086", italic = true })
---
---   -- Link to another group
---   hl.set("MyError", { link = "DiagnosticError" })
---
---   -- Bulk-set many groups at once
---   hl.bulk({
---     Normal      = { fg = "#cdd6f4", bg = "#1e1e2e" },
---     Comment     = { fg = "#6c7086", italic = true },
---     CursorLine  = { bg = "#313244" },
---     ["@keyword"] = { fg = "#cba6f7", bold = true },
---   })
---
---   -- Namespace support (for extmarks / virtual text)
---   hl.set("VirtText", { fg = "#a6e3a1", italic = true }, { ns = my_ns_id })

local M = {}

-- ─── Internal helpers ────────────────────────────────────────────────────────

--- Recognised boolean style keys that map directly to nvim_set_hl opts.
local STYLE_KEYS = {
	bold = true,
	italic = true,
	underline = true,
	undercurl = true,
	underdouble = true,
	underdotted = true,
	underdashed = true,
	strikethrough = true,
	reverse = true,
	standout = true,
	nocombine = true,
	default = true,
	-- Not boolean, but still valid opts passed through as-is:
	-- blend, url, sp (special/undercurl colour)
}

--- Colour formats accepted:
---   "#rrggbb"  — hex string  (kept as-is; Neovim ≥0.8 handles it natively)
---   0xRRGGBB   — integer literal
---   "NONE"     — clears the attribute (kept as-is)
---   nil        — attribute omitted

local function validate_color(value, field)
	if value == nil then
		return nil
	end
	local t = type(value)
	if t == "number" then
		assert(
			value >= 0 and value <= 0xFFFFFF,
			("highlights: %s integer 0x%X is out of 24-bit range"):format(field, value)
		)
		return value
	end
	if t == "string" then
		local upper = value:upper()
		if upper == "NONE" then
			return "NONE"
		end
		assert(
			value:match("^#%x%x%x%x%x%x$"),
			("highlights: %s %q is not a valid hex colour (#rrggbb) or 'NONE'"):format(field, value)
		)
		return value
	end
	error(("highlights: %s must be a string or integer, got %s"):format(field, t))
end

--- Build the opts table expected by vim.api.nvim_set_hl.
local function build_opts(spec)
	assert(type(spec) == "table", "highlights: spec must be a table")

	-- Link shortcut — if `link` is present the rest is ignored (Neovim behaviour)
	if spec.link ~= nil then
		assert(type(spec.link) == "string", "highlights: 'link' must be a string group name")
		return { link = spec.link }
	end

	local opts = {}

	-- Colours
	opts.fg = validate_color(spec.fg, "fg")
	opts.bg = validate_color(spec.bg, "bg")
	opts.sp = validate_color(spec.sp, "sp") -- special (undercurl colour)
	opts.ctermfg = spec.ctermfg -- pass through for terminal colour support
	opts.ctermbg = spec.ctermbg

	-- Boolean style attributes
	for key in pairs(STYLE_KEYS) do
		if spec[key] ~= nil then
			assert(type(spec[key]) == "boolean", ("highlights: '%s' must be a boolean"):format(key))
			opts[key] = spec[key]
		end
	end

	-- Blend (0–100 integer)
	if spec.blend ~= nil then
		assert(
			type(spec.blend) == "number" and spec.blend >= 0 and spec.blend <= 100,
			"highlights: 'blend' must be an integer between 0 and 100"
		)
		opts.blend = spec.blend
	end

	-- URL (Neovim ≥0.10)
	if spec.url ~= nil then
		assert(type(spec.url) == "string", "highlights: 'url' must be a string")
		opts.url = spec.url
	end

	-- Force-override existing highlight (default: false)
	opts.force = (spec.force == true)

	return opts
end

-- ─── Public API ──────────────────────────────────────────────────────────────

--- Set a single highlight group.
---
---@param group string        The highlight group name, e.g. "Normal" or "@keyword".
---@param spec  table         Highlight spec (see module doc above).
---@param opts? {ns?: integer}  Optional: `ns` = namespace id (default 0 = global).
function M.set(group, spec, opts)
	assert(type(group) == "string" and group ~= "", "highlights.set: group must be a non-empty string")

	local ns = (opts and opts.ns) or 0
	local hl_opts = build_opts(spec)

	local ok, err = pcall(vim.api.nvim_set_hl, ns, group, hl_opts)
	if not ok then
		vim.notify(("highlights.set: failed to set '%s': %s"):format(group, err), vim.log.levels.ERROR)
	end
end

--- Set multiple highlight groups at once.
---
---@param groups table<string, table>  Map of group name → spec.
---@param opts?  {ns?: integer}        Same options as M.set.
function M.bulk(groups, opts)
	assert(type(groups) == "table", "highlights.bulk: groups must be a table")
	for group, spec in pairs(groups) do
		M.set(group, spec, opts)
	end
end

--- Clear a highlight group (resets it to default/nothing).
---
---@param group string
---@param opts? {ns?: integer}
function M.clear(group, opts)
	M.set(group, {}, opts)
end

--- Link one highlight group to another (convenience wrapper).
---
---@param group  string  The group to define.
---@param target string  The group to link to.
---@param opts?  {ns?: integer}
function M.link(group, target, opts)
	M.set(group, { link = target }, opts)
end

--- Retrieve the current resolved attributes of a highlight group.
--- Returns a table with fields like fg, bg, bold, italic, etc.
---
---@param group string
---@param opts? {ns?: integer, resolve?: boolean}
---@return table
function M.get(group, opts)
	local ns = (opts and opts.ns) or 0
	local resolve = (opts and opts.resolve) -- if true, follow links
	return vim.api.nvim_get_hl(ns, {
		name = group,
		link = not resolve, -- when resolve=true, don't return link, expand it
	})
end

--- Extend an existing highlight group with additional / overriding attributes.
--- Useful for adding bold to an existing group without redefining its colours.
---
---@param group string
---@param spec  table         Partial spec to merge on top.
---@param opts? {ns?: integer}
function M.extend(group, spec, opts)
	local ns = (opts and opts.ns) or 0
	local existing = vim.api.nvim_get_hl(ns, { name = group, link = false })

	-- Convert integer colours back to hex strings for our builder
	local function int_to_hex(n)
		if type(n) == "number" then
			return ("#%06x"):format(n)
		end
		return n
	end

	local base = {
		fg = int_to_hex(existing.fg),
		bg = int_to_hex(existing.bg),
		sp = int_to_hex(existing.sp),
		bold = existing.bold,
		italic = existing.italic,
		underline = existing.underline,
		undercurl = existing.undercurl,
		underdouble = existing.underdouble,
		underdotted = existing.underdotted,
		underdashed = existing.underdashed,
		strikethrough = existing.strikethrough,
		reverse = existing.reverse,
		blend = existing.blend,
		nocombine = existing.nocombine,
	}

	-- Merge: incoming spec wins over base
	local merged = vim.tbl_extend("force", base, spec)
	M.set(group, merged, opts)
end

-- configuration starts here
M.bulk({
	Comment = { italic = true },
	Booleans = { italic = true },
	Directory = { italic = true },
	MatchParen = { underline = true },
	WinSeparator = { fg = "#dbdbff" },
	TablineAct = { bold = true, italic = true },
})

return M
