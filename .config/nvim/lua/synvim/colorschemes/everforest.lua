-- SynVim Everforest Theme
return {
  "neanias/everforest-nvim",
  lazy = true,
  config = function()
    -- vim.cmd([[colorscheme everforest]])

    require("everforest").setup({
      transparent_background_level = 2,
      italics = true,
      ui_contrast = "high",
      dim_inactive_windows = false,
      float_style = "dim"
    })
  end,
}
