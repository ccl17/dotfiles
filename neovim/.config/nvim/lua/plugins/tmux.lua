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

    local f = require('util/functions')
    local noremap = f.noremap
    local zoom = function()
      if vim.fn.winnr('$') > 1 then
        if vim.g.zoomed ~= nil then
          vim.cmd(vim.g.zoom_winrestcmd)
          vim.g.zoomed = 0
        else
          vim.g.zoom_winrestcmd = vim.fn.winrestcmd()
          vim.cmd('resize')
          vim.cmd('vertical resize')
          vim.g.zoomed = 1
        end
      else
        vim.cmd('!tmux resize-pane -Z')
      end
    end
    noremap('n', '<leader>z', zoom, 'tmux zoom')
  end,
}
