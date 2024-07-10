local keymap = vim.keymap

local M = {}

function M.map(type, input, output, description, options)
  options = options or {}
  keymap.set(type, input, output, vim.tbl_deep_extend('force', { remap = true, desc = description }, options))
end

function M.noremap(type, input, output, description, options)
  options = options or {}
  M.map(type, input, output, description, vim.tbl_deep_extend('force', { remap = false }, options))
end

---@param buf? number
function M.enabled(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local gaf = vim.g.autoformat
  local baf = vim.b[buf].autoformat

  -- If the buffer has a local value, use that
  if baf ~= nil then return baf end

  -- Otherwise use the global value if set, or true by default
  return gaf == nil or gaf
end

---@param buf? boolean
function M.toggle(buf)
  if buf then
    vim.b.autoformat = not M.enabled()
  else
    vim.g.autoformat = not M.enabled()
    vim.b.autoformat = nil
  end
end

return M
