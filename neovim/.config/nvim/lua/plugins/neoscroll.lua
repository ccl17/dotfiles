return {
  'karb94/neoscroll.nvim',
  enabled = true,
  config = function()
    require('neoscroll').setup({
      easing = 'sine',
    })
  end,
}
