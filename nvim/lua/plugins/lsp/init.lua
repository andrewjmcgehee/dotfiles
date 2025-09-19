local M = {}

function M.action(name)
  return function()
    vim.lsp.buf.code_action({
      apply = true,
      context = {
        only = { name },
        diagnostics = {},
      },
    })
  end
end

function M.execute_action(name)
  local fn = M.action(name)
  fn()
end

return M
