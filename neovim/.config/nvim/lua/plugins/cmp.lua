return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    { 'L3MON4D3/LuaSnip' },
    { 'saadparwaiz1/cmp_luasnip' },

    -- Adds LSP completion capabilities
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },

    -- Adds a number of user-friendly snippets
    { 'rafamadriz/friendly-snippets' },

    -- Adds vscode-like pictograms
    { 'onsails/lspkind.nvim' },

    { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },
    { 'abecodes/tabout.nvim', event = 'InsertCharPre' },
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    require('luasnip.loaders.from_vscode').lazy_load()
    luasnip.config.setup({})

    cmp.setup({
      snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
      },
      completion = {
        completeopt = 'menu,menuone,noinsert',
      },
      mapping = cmp.mapping.preset.insert({
        ['<c-b>'] = cmp.mapping.scroll_docs(-4),
        ['<c-f>'] = cmp.mapping.scroll_docs(4),
        ['<c-space>'] = cmp.mapping.complete({}),
        ['<cr>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
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
      }),
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'treesitter' },
      },
      formatting = {
        format = function(entry, vim_item)
          local lspkind = require('lspkind')
          -- From lspkind
          return lspkind.cmp_format()(entry, vim_item)
        end,
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

    cmp.setup.filetype('sql', {
      sources = {
        { name = 'vim-dadbod-completion' },
        { name = 'buffer' },
      },
    })

    require('tabout').setup({ completion = false })
  end,
}
