return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '<leader>fe', function() require('oil').open() end, desc = 'open parent directory' },
    { '<leader>fE', function() require('oil').open(vim.fn.getcwd()) end, desc = 'open project root directory' },
  },
  opts = {
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    keymaps = {
      ['?'] = 'actions.show_help',
      ['q'] = 'actions.close',
      ['<cr>'] = 'actions.select',
      ['<c-v>'] = { 'actions.select', opts = { vertical = true }, desc = 'open vertical split' },
      ['<c-x>'] = { 'actions.select', opts = { horizontal = true }, desc = 'open horizontal split' },
      ['-'] = 'actions.parent',
    },
    use_default_keymaps = false,
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, _) return name == '..' end,
    },
  },
}
