local f = require('util/functions')

return {
  { 'tpope/vim-fugitive', lazy = false },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = 'tpope/vim-dadbod',
    cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection' },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      f.noremap('n', '<leader>db', '<cmd>DBUIToggle<CR>', 'dadbod UI toggle')
    end,
  },
}
