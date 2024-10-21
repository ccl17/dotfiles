local M = {}

---@param buf? boolean
function M.toggle_autoformat(buf)
  if buf then
    vim.b.autoformat = not autoformat_enabled(buf)
  else
    vim.g.autoformat = not autoformat_enabled(buf)
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

return M
