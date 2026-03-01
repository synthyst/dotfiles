-- SynVim Lualine Plugin
-- Minimal statusline with time

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "lewis6991/gitsigns.nvim",
    "otavioschwanck/arrow.nvim",
  },
  lazy = false,
  -- enabled = false,
  config = function()
    local lualine = require("lualine")
    -- Mode icon map
    local mode_icons = {
      n = "󰆾 ",
      i = " ",
      v = "󰩭 ",
      V = "󰕞 ",
      R = "󰬴 ",
      [vim.api.nvim_replace_termcodes("<C-v>", true, true, true)] = "󰙨", -- Visual Block mode (CTRL-V)
      c = "󰘳 ",
      t = " ",
    }
    local function arrow()
      local status = require("arrow.statusline").text_for_statusline_with_icons()

      return status
    end

    lualine.setup({
      options = {
        theme = 'rose-pine',
        globalstatus = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        always_show_tabline = true,
      },
      extensions = { 'quickfix', 'lazy' },
      sections = {
        -- Left: mode icon
        lualine_a = {
          {
            function()
              local mode = vim.fn.mode()
              return mode_icons[mode] or mode
            end,
            separator = { left = '', right = '' },
            color = { gui = 'bold' },
            padding = { left = 0.8, right = 0.8 },
          },
        },
        -- Middle-left: git branch and diff
        lualine_b = {
          {
            'filename',
            file_status = true,
            shorting_target = 70,
            color = { gui = 'italic' },
            path = 1,
            separator = { right = '' },
            symbols = {
              modified = '~',
              readonly = '-',
              unnamed = '',
              newfile = '',
            }
          },
          {
            arrow,
          },

          { 'lazy' },
          { 'quickfix' },
          {
            require("noice").api.status.mode.get,
            cond = require("noice").api.status.mode.has,
            color = { gui = 'bold', 'italic' },
          },
        },
        -- Middle: truncated file path with modified indicator
        lualine_c = {
          {
            "diff",
            symbols = { added = "", modified = "", removed = "" },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
          {
            'diagnostics',
            sections = { 'error', 'warn', 'info', 'hint' },
            colored = true,
          },
        },
        -- Right side: LSP, buffer count, time, filetype
        lualine_x = {
          {
            'lsp_status',
            color = { gui = 'italic' },
            colored = true,
            icon = '󰒏',
          },
        },
        lualine_y = {
          {
            'location',
            padding = { left = 0, right = 1 },
            separator = { left = '' },
          },
          {
            'searchcount'
          },
          {
            'selectioncount',
          }
        },
        lualine_z = {
          {
            "filetype",
            colored = false,
            icon_only = true,
            icon = { align = "left" },
            padding = { left = 1, right = 1 },
          },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {

        },
        lualine_x = {
          {
            "filetype",
            colored = true,
            icon_only = true,
          },
        },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {
        lualine_b = {
          {
            'buffers',
            show_modified_status = true,
            show_filename_only = true, -- Shows shortened relative path when set to false.
            use_mode_colors = true,
            max_length = vim.o.columns * 4,

            symbols = {
              alternate_file = '¿',
              modified = '~'
            },
          },
          {
            "branch",
            icon = "󰘬",
            color = { gui = 'bold' },
            separator = { right = '' },
          },
        },
        lualine_z = {
          {
            'tabs',
            mode = 0,
            use_mode_colors = true,
            show_modified_status = false,
          },
        }
      },
    })
  end,
}
