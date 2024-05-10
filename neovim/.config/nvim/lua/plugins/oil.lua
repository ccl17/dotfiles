local f = require('util.functions')

return {
  'stevearc/oil.nvim',
  keys = {
    { '-', '<cmd>Oil<cr>', desc = 'open parent directory' },
  },
  opts = {
    view_options = { show_hidden = true },
  },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
