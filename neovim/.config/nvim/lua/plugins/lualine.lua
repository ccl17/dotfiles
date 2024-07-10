local f, icons = require('util.functions'), require('util.icons')
local function autoformat_enabled() return f.enabled() and '󱪚' or '󱪘' end

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
            error = icons.diagnostics.error .. ' ',
            warn = icons.diagnostics.warning .. ' ',
            info = icons.diagnostics.information .. ' ',
            hint = icons.diagnostics.hint .. ' ',
          },
        },
        { 'fancy_searchcount' },
      },
      lualine_x = {
        { autoformat_enabled, padding = 1 },
        { 'fancy_lsp_servers', icon = '󰆧' },
        { 'progress' },
        { 'fancy_location' },
      },
      lualine_y = {},
      lualine_z = {},
    },
  },
}
