local M = {}

---@param buf? boolean
function M.toggle_autoformat(buf)
  if buf then
    vim.b.autoformat = not M.autoformat_enabled()
    vim.notify(string.format('autoformat %s', vim.b.autoformat and 'enabled' or 'disabled'), vim.log.levels.INFO)
  else
    vim.g.autoformat = not M.autoformat_enabled()
    vim.notify(string.format('autoformat %s', vim.g.autoformat and 'enabled' or 'disabled'), vim.log.levels.INFO)
    vim.b.autoformat = nil
  end
end

---@param buf? number
function M.autoformat_enabled(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local gaf = vim.g.autoformat
  local baf = vim.b[buf].autoformat

  -- if buffer has local value, use that
  if baf ~= nil then return baf end

  -- otherwise use the global value if set, or true by default
  return gaf == nil or gaf
end

function M.toggle_inlayhint()
  vim.g.inlay_hints = not vim.g.inlay_hints
  vim.notify(string.format('inlay hints %s', vim.g.inlay_hints and 'enabled' or 'disabled'), vim.log.levels.INFO)

  local mode = vim.api.nvim_get_mode().mode
  vim.lsp.inlay_hint.enable(vim.g.inlay_hints and (mode == 'n' or mode == 'v'))
end

---@param ms integer
---@param fn function
function M.debounce(ms, fn)
  local timer = vim.uv.new_timer()
  return function(...)
    local argv = { ... }
    timer:start(ms, 0, function()
      timer:stop()
      vim.schedule_wrap(fn)(unpack(argv))
    end)
  end
end

return M
