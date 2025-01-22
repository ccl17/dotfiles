return {
  {
    'ruifm/gitlinker.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { mappings = '<leader>gc' },
    config = function()
      require('gitlinker').setup()
      vim.api.nvim_set_keymap(
        'n',
        '<leader>gY',
        '<cmd>lua require"gitlinker".get_repo_url()<cr>',
        { silent = true, desc = 'copy git repository URL' }
      )
      vim.api.nvim_set_keymap(
        'n',
        '<leader>gB',
        '<cmd>lua require"gitlinker".get_repo_url({action_callback = require"gitlinker.actions".open_in_browser})<cr>',
        { silent = true, desc = 'open git repository URL in browser' }
      )
    end,
  },
}
