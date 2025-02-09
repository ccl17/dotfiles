local icons = require('icons')
return {
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('ibl').setup({
        indent = {
          char = {
            icons.indent.indent1,
            icons.indent.indent2,
            icons.indent.indent3,
            icons.indent.indent4,
          },
        },
        scope = { enabled = false },
      })
      require('mini.indentscope').setup({
        draw = {
          delay = 50,
        },
        symbol = icons.misc.vertical_bar,
        options = { try_as_border = true },
      })
    end,
  },
  {
    'echasnovski/mini.indentscope',
    version = '*',
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'checkhealth', 'fzf', 'help', 'lazy', 'lspinfo', 'man', 'mason', 'notify', '' },
        callback = function() vim.b.miniindentscope_disable = true end,
      })
    end,
  },
}
