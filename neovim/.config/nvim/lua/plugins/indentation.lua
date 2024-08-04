return {
  {
    'lukas-reineke/indent-blankline.nvim',
    version = 'v3.5.4',
    main = 'ibl',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('ibl').setup({
        indent = {
          char = { '|', '¦', '┆', '┊' },
        },
        scope = { enabled = false },
      })
      require('mini.indentscope').setup({
        draw = {
          delay = 50,
        },
        symbol = '▏',
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
