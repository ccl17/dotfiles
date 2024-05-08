return {
  'aserowy/tmux.nvim',
  event = 'VeryLazy',
  config = function()
    require('tmux').setup({
      navigation = {
        cycle_navigation = false,
        enable_default_keybindings = true,
        persist_zoom = true,
      },
    })
  end,
}
