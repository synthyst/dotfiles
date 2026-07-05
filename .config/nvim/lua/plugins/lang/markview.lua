return {
	"OXY2DEV/markview.nvim",
	ft = { "markdown", "quarto", "yaml", "latex", "html" },
	event = "BufReadPost",
	dependencies = { "saghen/blink.cmp" },
	config = function()
		---@class markview.config
		---@type markview.config
		require("markview").setup({
			markdown = {
				headings = {
					heading_1 = { style = "label", align = "center" },
					heading_2 = { style = "label", align = "center" },
					heading_3 = { style = "label", align = "center" },
					heading_4 = { style = "label", align = "center" },
					heading_5 = { style = "label", align = "center" },
					heading_6 = { style = "label", align = "center" },
				},
				-- horizontal_rules = require("markview.presets").horizontal_rules.arrowed,
				tables = require("markview.presets").tables.none,
				block_quotes = {
					wrap = 3,
				},
			},
			html = {
				enable = true,
			},
			typst = {
				enable = true,
			},
			preview = {
				icon_provider = "mini",
			},
			latex = {
				enable = true,
			},
			experimental = {
				prefer_nvim = true,
			},
			markdown_inline = {
				tags = {
					default = {
						hl = "MarkviewCodeInfo",
						padding_left = "",
						padding_left_hl = "MarkviewCodeFg",
						padding_right = "",
						padding_right_hl = "MarkviewCodeFg",
					},
					enable = true,
				},
			},
		})
		require("markview.extras.editor").setup()
	end,
}
