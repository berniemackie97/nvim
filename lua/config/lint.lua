local M = {}

function M.is_enabled(buf)
  if vim.g.lint_enabled == false then
    return false
  end
  if buf then
    local value = vim.b[buf].lint_enabled
    if value ~= nil then
      return value
    end
  end
  return true
end

function M.toggle(buf)
  if buf then
    local bufnr = buf == true and vim.api.nvim_get_current_buf() or buf
    local next_state = not M.is_enabled(bufnr)
    vim.b[bufnr].lint_enabled = next_state
    return next_state
  end

  local next_state = vim.g.lint_enabled == false
  vim.g.lint_enabled = next_state
  vim.b.lint_enabled = nil
  return next_state
end

return M
