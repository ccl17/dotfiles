local api, keymap = vim.api, vim.keymap

local M = {}

function M.map(type, input, output, description, options)
  options = options or {}
  keymap.set(type, input, output, vim.tbl_deep_extend('force', { remap = true, desc = description }, options))
end

function M.noremap(type, input, output, description, options)
  options = options or {}
  M.map(type, input, output, description, vim.tbl_deep_extend('force', { remap = false }, options))
end

function M.autoformat_enabled(buf)
  buf = (buf == nil or buf == 0) and api.nvim_get_current_buf() or buf
  local g = vim.g.autoformat
  local b = vim.b[buf].autoformat
  -- If the buffer has a local value, use that
  if b ~= nil then return b end
  -- Otherwise use the global value if set, or true by default
  return g == nil or g
end

function M.toggle_autoformat(buf)
  if buf then
    vim.b.autoformat = not M.autoformat_enabled()
  else
    vim.g.autoformat = not M.autoformat_enabled()
    vim.b.autoformat = nil
  end
end

return M
