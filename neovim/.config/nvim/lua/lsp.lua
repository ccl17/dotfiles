local function on_attach(client, bufnr)
    if client:supports_method 'textDocument/signatureHelp' then
        vim.keymap.set('i', '<C-k>', function()
            -- Close the completion menu first (if open).
            if require('blink.cmp.completion.windows.menu').win:is_open() then
                require('blink.cmp').hide()
            end

            vim.lsp.buf.signature_help()
        end, { desc = 'Signature help', buffer = bufnr})
    end

    if client:supports_method 'textDocument/documentHighlight' then
        local under_cursor_highlights_group = vim.api.nvim_create_augroup('sc/cursor_highlights', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave' }, {
            group = under_cursor_highlights_group,
            desc = 'Highlight references under the cursor',
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
            group = under_cursor_highlights_group,
            desc = 'Clear highlight references',
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })
    end

    if client:supports_method('textDocument/inlayHint') then
      vim.keymap.set('n', '<leader>xi', function ()
        local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr})
        vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr})
      end)
    end

    if client.supports_method('textDocument/codeLens') then
      local code_lens_group = vim.api.nvim_create_augroup('sc/code_lens', { clear = false})
      vim.api.nvim_create_autocmd('LspProgress', {
        group = code_lens_group,
        callback = function (ev)
          if ev.buf == bufnr then
            vim.lsp.codelens.refresh({bufnr=bufnr})
          end
        end
      })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'TextChanged', 'InsertLeave'}, {
        group = code_lens_group,
        buffer = bufnr,
        callback = function ()
          vim.lsp.codelens.refresh({bufnr=bufnr})
        end
      })
      vim.lsp.codelens.refresh({bufnr=bufnr})
    end

    if client:supports_method('textDocument/foldingRange') then
      vim.wo.foldmethod = 'expr'
      vim.wo.foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end

    if client.name == 'gopls' then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        callback = function ()
          local params = vim.lsp.util.make_range_params()
          params.context = { only = {'source.organizeImports'}}
          local result = vim.lsp.buf_request_sync(bufnr, 'textDocument/codeAction', params)
          for _, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
              end
            end
          end
        end
      })
    end
end

vim.diagnostic.config({
  virtual_text = {
    prefix = '',
    spacing = 2,
  },
})

local register_capability = vim.lsp.handlers['client/registerCapability']
vim.lsp.handlers['client/registerCapability'] = function(err, res, ctx)
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
  end
})

        vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities(nil, true) })

        local servers = vim.iter(vim.api.nvim_get_runtime_file('lsp/*.lua', true))
            :map(function(file)
                return vim.fn.fnamemodify(file, ':t:r')
            end)
            :totable()
        vim.lsp.enable(servers)
