return {
  url = "https://git.sr.ht/~adigitoleo/haunt.nvim",
  cmd = { "HauntTerm", "HauntMan", "HauntHelp" },
  config = function()
    require('haunt').setup({
		window = {
			width_frac = 0.9,
			height_frac = 0.9,
			winblend = 50,
			title_pos = "center",
		},
  })
  end,
}
