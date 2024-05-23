local f = require('util.functions')

return {
  'rcarriga/nvim-notify',
  config = function(opts)
    require('notify').setup({
      top_down = false,
      background_colour = '#000000',
    })
    f.noremap('n', '<leader>n', function() require('notify').dismiss({ pending = true }) end, 'dismiss notifications')
  end,
}
