return {
  'hrsh7th/nvim-cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    { 'L3MON4D3/LuaSnip', version = 'v2.*', build = 'make install_jsregexp' },

    -- cmp sources
    { 'saadparwaiz1/cmp_luasnip' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-cmdline' },
    { 'rcarriga/cmp-dap' },

    -- Adds a number of user-friendly snippets
    { 'rafamadriz/friendly-snippets' },

    { 'onsails/lspkind.nvim' },
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    require('luasnip.loaders.from_vscode').lazy_load()

    local winhighlight = 'Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None'

    local lspkind = require('lspkind')

    cmp.setup({
      snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
      },
      completion = {
        completeopt = 'menu,menuone,noinsert',
      },
      preselect = cmp.PreselectMode.None,
      mapping = {
        ['<c-b>'] = cmp.mapping.scroll_docs(-4),
        ['<c-f>'] = cmp.mapping.scroll_docs(4),
        ['<c-c>'] = cmp.mapping.complete(),
        ['<c-e>'] = cmp.mapping.abort(),
        ['<cr>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        }),
        ['<tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<s-tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp', keyword_length = 2 },
        {
          name = 'luasnip',
          -- Don't show snippet completions in comments or strings.
          entry_filter = function()
            local ctx = require('cmp.config.context')
            local in_string = ctx.in_syntax_group('String') or ctx.in_treesitter_capture('string')
            local in_comment = ctx.in_syntax_group('Comment') or ctx.in_treesitter_capture('comment')

            return not in_string and not in_comment
          end,
        },
      }, {
        { name = 'buffer' },
      }),
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = lspkind.cmp_format({
          mode = 'symbol',
          preset = 'codicons',
        }),
      },
      window = {
        completion = {
          winhighlight = winhighlight,
        },
        documentation = {
          winhighlight = winhighlight,
          max_height = math.floor(vim.o.lines * 0.5),
          max_width = math.floor(vim.o.columns * 0.4),
        },
      },
      experimental = {
        ghost_text = true,
      },
      performance = {
        max_view_entries = 10,
      },
    })

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        { name = 'cmdline' },
      }),
    })

    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' },
        { name = 'cmdline' },
      },
    })

    cmp.setup.filetype('sql', {
      sources = {
        { name = 'vim-dadbod-completion' },
        { name = 'buffer' },
      },
    })

    cmp.setup.filetype({ 'dap-repl', 'dapui_watches' }, { sources = { { name = 'dap' } } })
  end,
}
