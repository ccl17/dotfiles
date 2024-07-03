local lsp, fn, diagnostic = vim.lsp, vim.fn, vim.diagnostic
local f, icons = require('util.functions'), require('util.icons')
local augroup, noremap = f.augroup, f.noremap

local provider = {
  HOVER = 'hoverProvider',
  RENAME = 'renameProvider',
  CODELENS = 'codeLensProvider',
  CODEACTIONS = 'codeActionProvider',
  FORMATTING = 'documentFormattingProvider',
  REFERENCES = 'referencesProvider',
  DEFINITION = 'definitionProvider',
  TYPE_DEFINITION = 'typeDefinitionProvider',
  DECLARATION = 'declarationProvider',
  IMPLEMENTATIONS = 'implementationProvider',
  SIGNATUREHELP = 'signatureHelpProvider',
}

local M = {}

local function setup_autocommands(client, bufnr)
  if client.server_capabilities[provider.CODELENS] then
    augroup(('LspCodeLens%d'):format(bufnr), {
      event = { 'BufEnter', 'InsertLeave', 'BufWritePost' },
      desc = 'LSP: Code Lens',
      buffer = bufnr,
      -- call via vimscript so that errors are silenced
      command = 'silent! lua vim.lsp.codelens.refresh()',
    })
  end
  if client.server_capabilities[provider.REFERENCES] then
    augroup(('LspReferences%d'):format(bufnr), {
      event = { 'CursorHold', 'CursorHoldI' },
      buffer = bufnr,
      desc = 'LSP: References',
      command = function() lsp.buf.document_highlight() end,
    }, {
      event = 'CursorMoved',
      desc = 'LSP: References Clear',
      buffer = bufnr,
      command = function() lsp.buf.clear_references() end,
    })
  end
end

fn.sign_define('DiagnosticSignHint', { text = icons.diagnostics.hint, texthl = 'DiagnosticSignHint' })
fn.sign_define('DiagnosticSignInfo', { text = icons.diagnostics.information, texthl = 'DiagnosticSignInfo' })
fn.sign_define('DiagnosticSignWarn', { text = icons.diagnostics.warning, texthl = 'DiagnosticSignWarn' })
fn.sign_define('DiagnosticSignError', { text = icons.diagnostics.error, texthl = 'DiagnosticSignError' })
diagnostic.config({ float = false })

local function prev_diagnostic(lvl)
  return function() diagnostic.goto_prev({ float = false, severity = { min = lvl } }) end
end

local function next_diagnostic(lvl)
  return function() diagnostic.goto_next({ float = false, severity = { min = lvl } }) end
end

local function setup_mappings(client, bufnr)
  local t = require('telescope.builtin')

  local mappings = {
    {
      'n',
      'gr',
      t.lsp_references,
      'goto references',
      { silent = true },
      capability = provider.REFERENCES,
    },
    {
      'n',
      'gd',
      t.lsp_definitions,
      'goto definition',
      { silent = true },
      capability = provider.DEFINITION,
    },
    {
      'n',
      'gt',
      t.lsp_type_definitions,
      'goto type definition',
      { silent = true },
      capability = provider.TYPE_DEFINITION,
    },
    {
      'n',
      'gi',
      t.lsp_implementations,
      'goto implementations',
      { silent = true },
      capability = provider.IMPLEMENTATIONS,
    },
    { 'n', 'K', lsp.buf.hover, 'hover', { silent = true }, capability = provider.HOVER },
    { 'n', 'ga', lsp.buf.code_action, 'code action', { silent = true }, capability = provider.CODEACTIONS },
    { 'n', 'gs', lsp.buf.signature_help, 'signature help', { silent = true }, capability = provider.SIGNATUREHELP },
    { 'n', '<leader>rn', ':IncRename', 'rename', capability = provider.RENAME },
    { 'n', '[d', prev_diagnostic(), 'goto prev diagnostic' },
    { 'n', ']d', next_diagnostic(), 'goto next diagnostic' },
  }

  for _, m in ipairs(mappings) do
    -- if not m.capability or (m.capability and client.server_capabilities[m.capability]) then
    --   noremap(m[1], m[2], m[3], m[4], vim.tbl_deep_extend('force', { buffer = bufnr }, m[5] or {}))
    -- end
    noremap(m[1], m[2], m[3], m[4], vim.tbl_deep_extend('force', { buffer = bufnr }, m[5] or {}))
  end
end

local function on_attach(client, bufnr)
  setup_autocommands(client, bufnr)
  setup_mappings(client, bufnr)
end

function M.setup()
  augroup('LspSetupCommands', {
    event = 'LspAttach',
    desc = 'setup the language server autocommands',
    command = function(args)
      local client = lsp.get_client_by_id(args.data.client_id)
      if client then
        on_attach(client, args.buf)
        return
      end
    end,
  })
end

return M
