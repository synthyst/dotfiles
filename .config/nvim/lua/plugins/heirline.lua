return {
	"rebelot/heirline.nvim",
	enabled = false,
	event = "UiEnter",
	config = function()
		require("heirline").setup({
			statusline = {},
			winbar = {},
			tabline = {},
			-- statuscolumn = {},
		})
	end,
}
