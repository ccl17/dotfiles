local servers = {
  bashls = {},
  dockerls = {},
  gopls = {
    settings = {
      gopls = {
        directoryFilters = { '-node_modules', '-vendor' },
        gofumpt = true,
        semanticTokens = true,
        usePlaceholders = true,
        analyses = { unusedparams = true },
        staticcheck = true,
      },
    },
  },
  jsonls = {},
  lua_ls = {
    settings = {
      Lua = {
        codeLens = { enable = true },
        hint = {
          enable = true,
          arrayIndex = 'Disable',
          setType = false,
          paramName = 'Disable',
          paramType = true,
        },
        format = { enable = false },
        diagnostics = {
          globals = { 'vim', 'P', 'describe', 'it', 'before_each', 'after_each', 'packer_plugins', 'pending' },
        },
        completion = { keywordSnippet = 'Replace', callSnippet = 'Replace' },
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  },
  solargraph = {
    cmd = { os.getenv('HOME') .. '/.rbenv/shims/solargraph', 'stdio' },
    init_options = {
      formatting = false,
    },
    settings = {
      solargraph = {
        diagnostics = false,
      },
    },
  },
  terraformls = {},
  tsserver = {},
  vuels = {
    filetypes = { 'javascript', 'vue' },
  },
  yamlls = {},
}

return function(name)
  local config = name and servers[name] or {}
  if not config then return end
  if type(config) == 'function' then config = config() end
  local ok, cmp_nvim_lsp = pcall(require, 'cmd_nvim_lsp')
  local capabilities = vim.tbl_deep_extend(
    'force',
    {},
    vim.lsp.protocol.make_client_capabilities(),
    ok and cmp_nvim_lsp.default_capabilities() or {}
  )
  config.capabilities = capabilities
  return config
end
