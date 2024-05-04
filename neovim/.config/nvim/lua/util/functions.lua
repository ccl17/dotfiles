local api, keymap = vim.api, vim.keymap

local M = {}

function M.augroup(name, ...)
  local commands = { ... }
  local id = api.nvim_create_augroup(name, { clear = true })
  for _, autocmd in ipairs(commands) do
    local is_callback = type(autocmd.command) == 'function'
    api.nvim_create_autocmd(autocmd.event, {
      group = name,
      pattern = autocmd.pattern,
      desc = autocmd.desc,
      callback = is_callback and autocmd.command or nil,
      command = not is_callback and autocmd.command or nil,
      once = autocmd.once,
      nested = autocmd.nested,
      buffer = autocmd.buffer,
    })
  end
  return id
end

function M.command(name, rhs, opts)
  opts = opts or {}
  api.nvim_create_user_command(name, rhs, opts)
end

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
