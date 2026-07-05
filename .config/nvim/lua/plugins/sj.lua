return {
	"Wansmer/treesj",
	keys = { "JJ", "JS", "JT" },
	dependencies = { "romus204/tree-sitter-manager.nvim" }, -- if you install parsers with `nvim-treesitter`
	config = function()
		require("treesj").setup({
			use_default_keymaps = false,
		})
		vim.keymap.set("n", "JT", require("treesj").toggle, { desc = "Justify toggle" })
		vim.keymap.set("n", "Jt", function()
			require("treesj").toggle({ split = { recursive = true } })
		end, { desc = "Justify toggle recursively" })
		vim.keymap.set("n", "JJ", require("treesj").join, { desc = "Justify join" })
		vim.keymap.set("n", "Jj", function()
			require("treesj").join({ split = { recursive = true } })
		end, { desc = "Justify join recursively" })
		vim.keymap.set("n", "JS", require("treesj").split, { desc = "Justify split" })
		vim.keymap.set("n", "Js", function()
			require("treesj").split({ split = { recursive = true } })
		end, { desc = "Justify split recursively" })
	end,
}
