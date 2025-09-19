local M = {}

function M.on_attach(on_attach, name)
  return vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and (not name or client.name == name) then
        return on_attach(client, buffer)
      end
    end,
  })
end

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

function M.trouble_open_command(params)
  require("trouble").open({
    mode = "lsp_command",
    params = params,
  })
end

function M.command(opts)
  return function()
    local params = {
      command = opts.command,
      arguments = opts.arguments,
    }
    return vim.lsp.buf_request(0, "workspace/executeCommand", params, opts.handler)
  end
end

function M.execute_command(opts)
  local fn = M.command(opts)
  fn()
end

return M
