return {
	"mfussenegger/nvim-lint",
	keys = {
		{
			"<leader>fl",
			function()
				require("lint").try_lint()
			end,
			desc = "File lint",
		},
	},
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			lua = { "luacheck" },
			python = { "ruff" },
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			json = { "jsonlint" },
			markdown = { "markdownlint" },
		}
	end,
}
