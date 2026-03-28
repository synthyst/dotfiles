return {
  'nvim-java/nvim-java',
  enabled = false,
  ft = { 'java' },
  config = function()
    require('java').setup()
    vim.lsp.enable('jdtls')
  end,
}
