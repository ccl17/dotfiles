return {
  'NvChad/nvim-colorizer.lua',
  cmd = 'ColorizerToggle',
  lazy = false,
  opts = {
    filetypes = {
      'css',
      'html',
      'javascript',
      'lua',
      'vue',
    },
    user_default_options = {
      mode = 'background',
    },
  },
  config = function(_, opts)
    require('colorizer').setup(opts)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = opts.filetypes,
      group = vim.api.nvim_create_augroup('Colorizer', { clear = true }),
      callback = function()
        vim.keymap.set('n', '<leader>ct', '<cmd>ColorizerToggle<cr>', { desc = 'colorizer toggle' })
      end,
    })
  end,
}
