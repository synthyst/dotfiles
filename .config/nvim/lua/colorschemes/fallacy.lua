return {
	dir = "~/.local/share/nvim/lazy/fallacy",
	lazy = false,
	enabled = false,
	priority = 1000,
	name = "fallacy",

	config = function()
		require("fallacy").setup({})
		-- vim.cmd.colorscheme("fallacy-everwinte")
	end,
}
