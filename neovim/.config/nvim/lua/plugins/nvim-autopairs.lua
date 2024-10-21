return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    require('nvim-autopairs').setup({
      check_ts = true,
      fast_wrap = {
        map = '<m-e>',
      },
    })
  end,
}
