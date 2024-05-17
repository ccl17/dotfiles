return {
  'stevearc/oil.nvim',
  keys = {
    { '-', '<cmd>Oil<cr>', desc = 'open parent directory' },
  },
  opts = {
    keymaps = {
      ['g?'] = 'actions.show_help',
      ['<CR>'] = 'actions.select',
      ['<c-s>'] = false,
      ['<c-h>'] = false,
      ['<c-v>'] = 'actions.select_vsplit',
      ['<c-t>'] = 'actions.select_tab',
      ['<c-p>'] = 'actions.preview',
      ['<c-c>'] = 'actions.close',
      ['<c-l>'] = 'actions.refresh',
      ['-'] = 'actions.parent',
      ['_'] = 'actions.open_cwd',
      ['`'] = 'actions.cd',
      ['~'] = 'actions.tcd',
      ['gs'] = 'actions.change_sort',
      ['gx'] = 'actions.open_external',
      ['g.'] = 'actions.toggle_hidden',
      ['g\\'] = 'actions.toggle_trash',
    },
    view_options = {
      show_hidden = true,
    },
  },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
