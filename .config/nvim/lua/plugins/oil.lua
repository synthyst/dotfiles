return {
	"stevearc/oil.nvim",
	dependencies = {
		{ "nvim-mini/mini.nvim", opts = {} },
	},
	lazy = true,
	event = "BufReadPost",
	keymap = { "-" },
	config = function()
		require("oil").setup({
			default_file_explorer = true,
			keymaps = {
				["l"] = "actions.select",
				["q"] = "actions.close",
				["h"] = { "actions.parent", mode = "n" },
				["g."] = { "actions.toggle_hidden", mode = "n" },
			},
			float = {
				border = "rounded",
			},
		})
		vim.keymap.set("n", "-", function()
			require("oil").toggle_float(nil, { preview = {} })
		end, { desc = "Explore directory" })
	end,
}
