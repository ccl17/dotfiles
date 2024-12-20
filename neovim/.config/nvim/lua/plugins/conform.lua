local util = require('util')

return {
  'stevearc/conform.nvim',
  event = { 'LspAttach', 'BufWritePre' },
  init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
  config = function()
    require('conform').setup({
      log_level = vim.log.levels.DEBUG,
      formatters_by_ft = {
        lua = { 'stylua' },
      },
      format_on_save = function(bufnr)
        if not util.autoformat_enabled(bufnr) then return end
        return { timeout_ms = 500 }
      end,
    })

    -- autoformat toggle
    vim.keymap.set(
      'n',
      '<leader>xf',
      function() util.toggle_autoformat(true) end,
      { desc = 'Toggle buffer autoformat' }
    )
    vim.keymap.set('n', '<leader>xF', function() util.toggle_autoformat() end, { desc = 'Toggle global autoformat' })

    -- gopls formatting with auto import
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*.go',
      callback = function(args)
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { 'source.organizeImports' } }
        -- buf_request_sync defaults to a 1000ms timeout. Depending on your
        -- machine and codebase, you may want longer. Add an additional
        -- argument after params if you find that you have to write the file
        -- twice for changes to be saved.
        -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
        local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params)
        for cid, res in pairs(result or {}) do
          for _, r in pairs(res.result or {}) do
            if r.edit then
              local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
              vim.lsp.util.apply_workspace_edit(r.edit, enc)
            end
          end
        end
        require('conform').format({ bufnr = args.buf })
      end,
    })
  end,
}
