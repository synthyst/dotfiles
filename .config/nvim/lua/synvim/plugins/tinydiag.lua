return {
  "rachartier/tiny-inline-diagnostic.nvim",
  lazy = true,
  opts = {
    preset = 'modern',
    options = {
      show_source = {
        if_many = true,
      },
      show_code = false,
      break_line = { enabled = true },
      -- Settings for multiline diagnostics
      multilines = {
        enabled = false,              -- Enable support for multiline diagnostic messages
        always_show = false,          -- Always show messages on all lines of multiline diagnostics
        trim_whitespaces = false,     -- Remove leading/trailing whitespace from each line
        tabstop = 2,                  -- Number of spaces per tab when expanding tabs
        severity = nil,               -- Filter multiline diagnostics by severity (e.g., { vim.diagnostic.severity.ERROR })
      },
    }
  }
}
