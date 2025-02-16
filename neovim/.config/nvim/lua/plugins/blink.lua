return {
  'saghen/blink.cmp',
  dependencies = 'rafamadriz/friendly-snippets',
  version = '*',
  event = 'InsertEnter',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      ['<c-c>'] = { 'show_documentation', 'hide_documentation' },
      ['<c-d>'] = { 'show' },
      ['<cr>'] = { 'accept', 'fallback' },
      ['<c-e>'] = { 'hide', 'fallback' },
      ['<tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
      ['<s-tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
      ['<c-p>'] = { 'select_prev', 'fallback' },
      ['<c-n>'] = { 'select_next', 'fallback' },
      ['<c-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<c-f>'] = { 'scroll_documentation_down', 'fallback' },
    },
    sources = {
      default = function()
        local sources = { 'lsp', 'buffer' }
        local ok, node = pcall(vim.treesitter.get_node)

        if
          ok
          and node
          and not vim.tbl_contains({ 'string', 'comment', 'line_comment', 'block_comment' }, node:type())
        then
          table.insert(sources, 'snippets')
          table.insert(sources, 'path')
        end

        return sources
      end,
    },
    completion = {
      ghost_text = {
        enabled = true,
      },
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
    },
    cmdline = {
      enabled = false,
    },
  },
  opts_extend = { 'sources.default' },
}
