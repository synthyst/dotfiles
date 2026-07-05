return {
	"saghen/blink.cmp",
	event = "BufRead",
	lazy = true,
	build = "cargo build --release",
	dependencies = {
		"rafamadriz/friendly-snippets",
		-- "saghen/blink.lib",
	},
	version = "1.*",

	opts = {
		keymap = {
			preset = "none",
			["<C-e>"] = { "hide", "fallback" },
			["<C-y>"] = { "accept", "select_and_accept", "fallback" },
			["<C-s>"] = { "snippet_forward", "fallback" },
			["<C-S>"] = { "snippet_backward", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
			["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
		},
		snippets = { preset = "default" },
		cmdline = {
			enabled = true,
			completion = {
				list = { selection = { preselect = false, auto_insert = true } },
				menu = { auto_show = true, draw = { columns = { { "label", "label_description" } } } },
			},
			sources = { "cmdline", "buffer", "path" },
		},
		completion = {
			keyword = { range = "prefix" },
			trigger = {
				show_on_backspace_in_keyword = true,
			},
			accept = {
				-- Write completions to the `.` register
				dot_repeat = true,
				-- Create an undo point when accepting a completion item
				create_undo_point = true,
			},

			list = { selection = { preselect = true, auto_insert = true } },
			menu = {
				scrollbar = false,
				border = "none",
				auto_show = true,
				auto_show_delay_ms = 300,
				draw = {
					snippet_indicator = "@",
					treesitter = { "lsp", "buffer" },
					columns = {
						{ "label" },
						{ "label_description", "kind", "kind_icon", gap = 1, "source_name" },
					},
				},
			},
			ghost_text = {
				enabled = true,
				show_with_selection = true,
				show_without_selection = false,
				show_with_menu = false,
				show_without_menu = true,
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 550,
				update_delay_ms = 550,
				treesitter_highlighting = true,
				window = {
					min_width = 10,
					max_width = 80,
					max_height = 20,
					winblend = 10,
					-- Note that the gutter will be disabled when border ~= 'rounded'
					scrollbar = true,
				},
			},
		},
		sources = {
			default = { "lsp", "buffer", "snippets", "path" },
		},
		-- 	providers = {
		-- 		lsp = {
		-- 			-- fallbacks = { "buffer" },
		-- 			enabled = true, -- Whether or not to enable the provider
		-- 		},
		-- 		path = {
		-- 			opts = {
		-- 				trailing_slash = true,
		-- 				label_trailing_slash = true,
		-- 				show_hidden_files_by_default = true,
		-- 				-- This limits memory use and responsiveness for very large folders.
		-- 				max_entries = 500,
		-- 			},
		-- 		},
		-- 		snippets = {
		-- 			opts = {
		-- 				-- Whether to use show_condition for filtering snippets
		-- 				use_show_condition = true,
		-- 				-- Whether to show autosnippets in the completion list
		-- 				show_autosnippets = false,
		-- 				-- Whether to prefer docTrig placeholders over trig when expanding regTrig snippets
		-- 				prefer_doc_trig = false,
		-- 				-- Whether to put the snippet description in the label description
		-- 				use_label_description = true,
		-- 			},
		-- 		},
		-- 	},
		-- },
		fuzzy = {
			implementation = "lua",

			max_typos = function(keyword)
				return math.floor(#keyword / 4)
			end,

			-- Frecency tracks the most recently/frequently used items and boosts the score of the item
			-- Note, this does not apply when using the Lua implementation.
			frecency = {
				enabled = false,
				path = vim.fn.stdpath("state") .. "/blink/cmp/frecency.dat",
			},
			use_proximity = true,
			sorts = {
				"exact",
				"score",
				"sort_text",
			},
		},
	},
}
