local methods = vim.lsp.protocol.Methods

vim.g.inlay_hints = false

--- Set up LSP keymaps and autocmds for current buffer
---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
  vim.keymap.set(
    'n',
    'gr',
    '<cmd>FzfLua lsp_references jump1=true ignore_current_line=true<cr>',
    { desc = 'Go to references' }
  )

  vim.keymap.set(
    'n',
    'gt',
    '<cmd>FzfLua lsp_typedefs jump1=true ignore_current_line=true<cr>',
    { desc = 'Go to type definition' }
  )

  vim.keymap.set('n', 'gra', '<cmd>FzfLua lsp_code_actions<cr>', { desc = 'Code action' })

  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })

  if client:supports_method(methods.textDocument_signatureHelp) then
    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help)
  end

  if client:supports_method(methods.textDocument_definition) then
    vim.keymap.set(
      'n',
      'gd',
      '<cmd>FzfLua lsp_definitions jump1=true ignore_current_line=true<cr>',
      { desc = 'Go to definition' }
    )
  end

  if client:supports_method(methods.textDocument_declaration) then
    vim.keymap.set(
      'n',
      'gD',
      '<cmd>FzfLua lsp_declarations jump1=true ignore_current_line=true<cr>',
      { desc = 'Go to declaration' }
    )
  end

  if client:supports_method(methods.textDocument_implementation) then
    vim.keymap.set(
      'n',
      'gi',
      '<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>',
      { desc = 'Goto implementations' }
    )
  end

  if client:supports_method(methods.textDocument_documentHighlight) then
    local document_highlight_group = vim.api.nvim_create_augroup('document-highlight', { clear = false })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave', 'FocusGained' }, {
      group = document_highlight_group,
      desc = 'Highlight references under the cursor',
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave', 'FocusLost' }, {
      group = document_highlight_group,
      desc = 'Clear highlight references',
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  if client:supports_method(methods.textDocument_inlayHint) then
    local inlay_hints_group = vim.api.nvim_create_augroup('inlay-hints', { clear = false })

    vim.defer_fn(function()
      local mode = vim.api.nvim_get_mode().mode
      if vim.g.inlay_hints then vim.lsp.inlay_hint.enable(mode == 'n' or mode == 'v', { bufnr = bufnr }) end
    end, 500)

    vim.keymap.set('n', '<leader>xi', function()
      vim.g.inlay_hints = not vim.g.inlay_hints
      vim.notify(string.format('inlay hints %s', vim.g.inlay_hints and 'enabled' or 'disabled'), vim.log.levels.INFO)

      local mode = vim.api.nvim_get_mode().mode
      vim.lsp.inlay_hint.enable(vim.g.inlay_hints and (mode == 'n' or mode == 'v'))
    end, { buffer = bufnr, desc = 'Toggle inlay hints' })

    vim.api.nvim_create_autocmd('InsertEnter', {
      group = inlay_hints_group,
      desc = 'Disable inlay hints',
      buffer = bufnr,
      callback = function()
        if vim.g.inlay_hints then vim.lsp.inlay_hint.enable(false, { bufnr = bufnr }) end
      end,
    })

    vim.api.nvim_create_autocmd('InsertLeave', {
      group = inlay_hints_group,
      desc = 'Enable inlay hints',
      buffer = bufnr,
      callback = function()
        if vim.g.inlay_hints then vim.lsp.inlay_hint.enable(true, { bufnr = bufnr }) end
      end,
    })
  end
end

local diag_signs = {
  ERROR = '',
  WARN = '',
  INFO = '󰌶',
  HINT = '󰋼',
}

vim.diagnostic.config({
  underline = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = diag_signs.ERROR,
      [vim.diagnostic.severity.WARN] = diag_signs.WARN,
      [vim.diagnostic.severity.INFO] = diag_signs.INFO,
      [vim.diagnostic.severity.HINT] = diag_signs.HINT,
    },
  },
  severity_sort = true,
  float = {
    source = true,
    prefix = function(diag)
      local level = vim.diagnostic.severity[diag.severity]
      vim.print(level)
      local prefix = string.format(' %s ', diag_signs[level])
      return prefix, 'Diagnostic' .. level:gsub('^%l', string.upper)
    end,
  },
})

-- Keymap to toggle diagnostics
vim.keymap.set('n', '<leader>xd', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  if vim.diagnostic.is_enabled() then
    vim.notify('Diagnostics are enabled')
  else
    vim.notify('Diagnostics are disabled')
  end
end, { desc = 'Toggle diagnostics' })
vim.keymap.set(
  'n',
  '[e',
  function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end,
  { desc = 'Previous error' }
)
vim.keymap.set(
  'n',
  ']e',
  function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end,
  { desc = 'Next error' }
)

local register_capability = vim.lsp.handlers[methods.client_registerCapability]
vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then return end

  on_attach(client, vim.api.nvim_get_current_buf())

  return register_capability(err, res, ctx)
end

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Configure LSP',
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if not client then return end

    on_attach(client, args.buf)
  end,
})

local server_configs = vim
  .iter(vim.api.nvim_get_runtime_file('lsp/*.lua', true))
  :map(function(file) return vim.fn.fnamemodify(file, ':t:r') end)
  :totable()
vim.lsp.enable(server_configs)
