return {
  'saghen/blink.cmp',
  dependencies = 'rafamadriz/friendly-snippets',
  version = '*',
  event = 'InsertEnter',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      ['<c-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<cr>'] = { 'accept', 'fallback' },
      ['<c-e>'] = { 'hide', 'fallback' },
      ['<tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
      ['<s-tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
      ['<c-p>'] = { 'select_prev', 'fallback' },
      ['<c-n>'] = { 'select_next', 'fallback' },
      ['<c-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<c-f>'] = { 'scroll_documentation_down', 'fallback' },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono',
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      cmdline = {},
    },
    completion = {
      ghost_text = {
        enabled = true,
      },
      menu = { border = 'single' },
      documentation = { enabled = true, window = { border = 'single' } },
    },
    signature = { enabled = true, window = { border = 'single' } },
  },
  opts_extend = { 'sources.default' },
}
