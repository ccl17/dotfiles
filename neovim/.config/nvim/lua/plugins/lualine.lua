local icons = require('icons')
local util = require('util')

local function autoformat_toggle_state()
  return util.autoformat_enabled() and icons.autoformat.enabled or icons.autoformat.disabled
end

return {
  'nvim-lualine/lualine.nvim',
  lazy = false,
  dependencies = { 'nvim-tree/nvim-web-devicons', 'meuter/lualine-so-fancy.nvim' },
  opts = {
    options = {
      theme = 'catppuccin',
      globalstatus = true,
      component_separators = { left = '|', right = '|' },
      section_separators = '',
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'fancy_branch' },
      lualine_c = {
        {
          'filename',
          path = 1,
          symbols = {
            modified = '',
          },
        },
        {
          'fancy_diagnostics',
          sources = { 'nvim_lsp' },
          symbols = {
            error = icons.diagnostics.ERROR .. ' ',
            warn = icons.diagnostics.WARN .. ' ',
            info = icons.diagnostics.INFO .. ' ',
            hint = icons.diagnostics.HINT .. ' ',
          },
        },
        { 'fancy_searchcount' },
      },
      lualine_x = {
        { autoformat_toggle_state, padding = 1 },
        { 'fancy_lsp_servers', icon = icons.misc.lsp_icon },
        { 'progress' },
        { 'fancy_location' },
      },
      lualine_y = {},
      lualine_z = {},
    },
  },
}
