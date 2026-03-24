-- SynVim - Performance-Focused Neovim Config for Termux
-- Main entry point
--
-- Load core settings first (sets leader key and options)
require("synvim.core.options")
require("synvim.core.keymaps").setup()
require("synvim.core.autocmds")
require("synvim.core.lazy")
require("synvim.core.lsp")

