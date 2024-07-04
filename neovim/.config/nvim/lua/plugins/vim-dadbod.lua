-- local f = require('util.functions')

return {
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      {
        'kristijanhusak/vim-dadbod-completion',
        ft = { 'sql', 'mysql' },
        lazy = true,
      },
    },
    cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection' },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      -- f.noremap('n', '<leader>db', '<cmd>DBUIToggle<CR>', 'dadbod UI toggle')
    end,
  },
}
