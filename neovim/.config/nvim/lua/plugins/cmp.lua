return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    { 'L3MON4D3/LuaSnip', version = 'v2.*', build = 'make install_jsregexp' },

    -- cmp sources
    { 'saadparwaiz1/cmp_luasnip' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },
    { 'rcarriga/cmp-dap' },
    { 'lukas-reineke/cmp-rg' },

    -- Adds a number of user-friendly snippets
    { 'rafamadriz/friendly-snippets' },

    -- Adds vscode-like pictograms
    { 'onsails/lspkind.nvim' },

    {
      'windwp/nvim-autopairs',
      event = 'InsertEnter',
      opts = { check_ts = true },
    },
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    require('luasnip.loaders.from_vscode').lazy_load()

    cmp.setup({
      snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
      },
      completion = {
        completeopt = 'menu,menuone,noinsert',
      },
      preselect = cmp.PreselectMode.Item,
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
        { name = 'luasnip', group_index = 1, max_item_count = 5 },
        { name = 'nvim_lsp', group_index = 1 },
        { name = 'buffer', group_index = 2, max_item_count = 5 },
        { name = 'path', group_index = 3 },
      }),
      formatting = {
        format = require('lspkind').cmp_format(),
      },
      experimental = {
        ghost_text = true,
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

    local autopairs = require('nvim-autopairs.completion.cmp')
    cmp.event:on('confirm_done', autopairs.on_confirm_done({ filetypes = { ruby = false } }))
  end,
}
