return {
	"stevearc/oil.nvim",
	dependencies = {
		{ "nvim-mini/mini.nvim", opts = {} },
		{
			"malewicz1337/oil-git.nvim",
			dependencies = { "stevearc/oil.nvim" },
			opts = {
				show_file_highlights = true,
				show_directory_highlights = false,
				show_ignored_files = true,
			},
		},
	},
	lazy = true,
	event = "BufReadPost",
	keymap = { "-" },
	config = function()
		require("lua.scripts.oil_stuff")
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
