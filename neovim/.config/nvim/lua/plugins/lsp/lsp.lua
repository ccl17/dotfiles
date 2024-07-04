local f, icons = require('util.functions'), require('util.icons')

local M = {}

local function setup_autocommands(client, bufnr)
  if client.supports_method('textDocument/documentHighlight') then
    local LspReferences = vim.api.nvim_create_augroup(('LspReferences%d'):format(bufnr), { clear = true })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = LspReferences,
      buffer = bufnr,
      callback = function() vim.lsp.buf.document_highlight() end,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      group = LspReferences,
      buffer = bufnr,
      callback = function() vim.lsp.buf.clear_references() end,
    })
  end
end

local function setup_mappings(_, bufnr)
  local mappings = {
    {
      'n',
      'gr',
      vim.lsp.buf.references,
      'goto references',
      { silent = true },
    },
    {
      'n',
      'gd',
      vim.lsp.buf.definition,
      'goto definition',
      { silent = true },
    },
    {
      'n',
      'gt',
      vim.lsp.buf.type_definition,
      'goto type definition',
      { silent = true },
    },
    {
      'n',
      'gi',
      vim.lsp.buf.implementation,
      'goto implementations',
      { silent = true },
    },
    { 'n', 'K', vim.lsp.buf.hover, 'hover', { silent = true } },
    { 'n', 'ga', vim.lsp.buf.code_action, 'code action', { silent = true } },
    { 'n', 'gs', vim.lsp.buf.signature_help, 'signature help', { silent = true } },
    { 'n', '<leader>rn', ':IncRename', 'rename' },
  }

  for _, m in ipairs(mappings) do
    f.noremap(m[1], m[2], m[3], m[4], vim.tbl_deep_extend('force', { buffer = bufnr }, m[5] or {}))
  end
end

local function setup_diagnostics()
  vim.fn.sign_define('DiagnosticSignHint', { text = icons.diagnostics.hint, texthl = 'DiagnosticSignHint' })
  vim.fn.sign_define('DiagnosticSignInfo', { text = icons.diagnostics.information, texthl = 'DiagnosticSignInfo' })
  vim.fn.sign_define('DiagnosticSignWarn', { text = icons.diagnostics.warning, texthl = 'DiagnosticSignWarn' })
  vim.fn.sign_define('DiagnosticSignError', { text = icons.diagnostics.error, texthl = 'DiagnosticSignError' })
end

local function on_attach(client, bufnr)
  setup_autocommands(client, bufnr)
  setup_mappings(client, bufnr)
  setup_diagnostics()
end

function M.setup()
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        on_attach(client, args.buf)
        return
      end
    end,
  })
end

return M
