local diagnostic_icons = require('icons').diagnostics
for sev, icon in pairs(diagnostic_icons) do
  local hl = 'DiagnosticSign' .. sev:sub(1, 1) .. sev:sub(2):lower()
  vim.fn.sign_define(hl, { text = icon, texthl = hl })
end

vim.api.nvim_create_autocmd('InsertEnter', {
  pattern = '*',
  callback = function()
    vim.diagnostic.config({
      virtual_lines = false,
    })
  end,
})

vim.api.nvim_create_autocmd({ 'BufReadPost', 'InsertLeave' }, {
  pattern = '*',
  callback = function()
    vim.diagnostic.config({
      virtual_lines = { current_line = true },
    })
  end,
})
