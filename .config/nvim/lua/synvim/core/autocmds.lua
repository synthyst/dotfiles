-- restore cursor to file position in previous editing session
vim.api.nvim_create_augroup("SynVim", { clear = true })

vim.api.nvim_create_autocmd("BufReadPost", {
	group = "SynVim",
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
			-- defer centering slightly so it's applied after render
			vim.schedule(function()
				vim.cmd.normal({ args = { "zz" }, bang = true })
			end)
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = "SynVim",
	pattern = "markdown",
	callback = function()
		vim.opt_local.conceallevel = 1
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "help", "quickfix" },
	group = "SynVim",
	callback = function()
		vim.keymap.set("n", "q", "<cmd>quit<cr>")
	end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
	group = "SynVim",
	callback = function(args)
		if vim.bo[args.buf].filetype ~= "markdown" then
			return
		end
		vim.cmd("RenderMarkdown buf_disable")
	end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
	group = "SynVim",
	callback = function(args)
		if vim.bo[args.buf].filetype ~= "markdown" then
			return
		end
		vim.cmd("RenderMarkdown buf_enable")
	end,
})

-- vim.api.nvim_create_autocmd("BufWritePre", {
-- group = render_markdown_group,
--   callback = function(event)
--     if event.match:match("^%w%w+:[\\/][\\/]") then return end
--     ---@diagnostic disable-next-line : undefined-field
--     local file = vim.loop.fs_realpath(event.match) or event.match
--     vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
--   end,
-- })

vim.api.nvim_create_autocmd("FileType", {
	group = "SynVim",
	pattern = { "gitcommit", "text" },
	callback = function()
		vim.opt_local.wrap = true
	end,
})

vim.api.nvim_create_autocmd("User", {
	group = "SynVim",
	pattern = "MiniFilesBufferUpdate",
	callback = function(args)
		local lines = vim.api.nvim_buf_get_lines(args.data.buf_id, 0, -1, false)
		---@diagnostic disable-next-line
		for i, line in ipairs(lines) do
			-- Use vim.loop.fs_stat() to get size, mtime, etc.
			-- Set extmarks with virtual text
		end
	end,
})

vim.api.nvim_create_autocmd("LspProgress", {
	---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
	callback = function(ev)
		local spinner = { "", "", "", "", "", "" }
		vim.notify(vim.lsp.status(), "info", {
			id = "lsp_progress",
			title = "LSP Progress",
			opts = function(notif)
				notif.icon = ev.data.params.value.kind == "end" and " "
					or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
			end,
		})
	end,
})

---@diagno-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = 'oil',
--   callback = function(args)
--     local bufnr = args.buf
--     vim.defer_fn(function()
--       if vim.api.nvim_buf_is_valid(bufnr)
--           and vim.bo[bufnr].filetype == "oil"
--       then
--         require('oil').toggle_preview()
--       end
--     end, 100)
--   end
-- })

vim.api.nvim_create_autocmd("User", {
	group = "SynVim",
	pattern = "MiniFilesActionRename",
	callback = function(event)
		require("snacks").rename.on_rename_file(event.data.from, event.data.to)
	end,
})

-- ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
-- local progress = vim.defaulttable()
-- vim.api.nvim_create_autocmd("LspProgress", {
-- 	---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
-- 	callback = function(ev)
-- 		local client = vim.lsp.get_client_by_id(ev.data.client_id)
-- 		local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
-- 		if not client or type(value) ~= "table" then
-- 			return
-- 		end
-- 		local p = progress[client.id]
--
-- 		for i = 1, #p + 1 do
-- 			if i == #p + 1 or p[i].token == ev.data.params.token then
-- 				p[i] = {
-- 					token = ev.data.params.token,
-- 					msg = ("[%3d%%] %s%s"):format(
-- 						value.kind == "end" and 100 or value.percentage or 100,
-- 						value.title or "",
-- 						value.message and (" **%s**"):format(value.message) or ""
-- 					),
-- 					done = value.kind == "end",
-- 				}
-- 				break
-- 			end
-- 		end
--
-- 		local msg = {} ---@type string[]
-- 		progress[client.id] = vim.tbl_filter(function(v)
-- 			return table.insert(msg, v.msg) or not v.done
-- 		end, p)
--
-- 		local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
-- 		vim.notify(table.concat(msg, "\n"), "info", {
-- 			id = "lsp_progress",
-- 			opts = function(notif)
-- 				notif.icon = #progress[client.id] == 0 and " "
-- 					or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
-- 			end,
-- 		})
-- 	end,
-- })
