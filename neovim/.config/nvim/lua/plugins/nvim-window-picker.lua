return {
  's1n7ax/nvim-window-picker',
  tag = 'stable',
  config = function()
    require('window-picker').setup({
      hint = 'floating-big-letter',
      selection_chars = 'asdfhjkl',
      filter_rules = {
        bo = {
          buftype = { 'help', 'terminal', 'nofile' }
        }
      }
    })
  end
}
