local M = {}

M._supports_method = {}

function M._check_methods(client, buffer)
  -- don't trigger on invalid buffers
  if not vim.api.nvim_buf_is_valid(buffer) then
    return
  end
  -- don't trigger on non-listed buffers
  if not vim.bo[buffer].buflisted then
    return
  end
  -- don't trigger on nofile buffers
  if vim.bo[buffer].buftype == "nofile" then
    return
  end
  for method, clients in pairs(M._supports_method) do
    clients[client] = clients[client] or {}
    if not clients[client][buffer] then
      if client.supports_method and client:supports_method(method, buffer) then
        clients[client][buffer] = true
        vim.api.nvim_exec_autocmds("User", {
          pattern = "LspSupportsMethod",
          data = { client_id = client.id, buffer = buffer, method = method },
        })
      end
    end
  end
end

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

function M.on_dynamic_capability(fn, opts)
  return vim.api.nvim_create_autocmd("User", {
    pattern = "LspDynamicCapability",
    group = opts and opts.group or nil,
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.buf
      if client then
        return fn(client, buffer)
      end
    end,
  })
end

function M.on_supports_method(method, fn)
  M._supports_method[method] = M._supports_method[method] or setmetatable({}, { __mode = "k" })
  return vim.api.nvim_create_autocmd("User", {
    pattern = "LspSupportsMethod",
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.buf
      if client and method == args.data.method then
        return fn(client, buffer)
      end
    end,
  })
end

function M.setup()
  local original_register = vim.lsp.handlers["client/registerCapability"]
  local modified_register = function(err, res, ctx)
    local ret = original_register(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client then
      for buffer in pairs(client.attached_buffers) do
        vim.api.nvim_exec_autocmds("User", {
          pattern = "LspDynamicCapability",
          data = { client_id = client.id, buffer = buffer },
        })
      end
    end
    return ret
  end
  vim.lsp.handlers["client/registerCapability"] = modified_register
  M.on_attach(M._check_methods)
  M.on_dynamic_capability(M._check_methods)
end

function M.keymap(mode, key, fn, buf, opts)
  local basic_opts = { buffer = buf, silent = true }
  opts = vim.tbl_deep_extend("force", opts, basic_opts)
  vim.keymap.set(mode, key, fn, opts)
end

function M.all_keymaps(client, buf)
  if client:supports_method("textDocument/definition") then
    M.keymap("n", "gd", vim.lsp.buf.definition, buf, { desc = "Goto Definition" })
  end
  if client:supports_method("textDocument/references") then
    M.keymap("n", "gr", vim.lsp.buf.references, buf, { desc = "References", nowait = true })
  end
  if client:supports_method("textDocument/implementation") then
    M.keymap("n", "gI", vim.lsp.buf.implementation, buf, { desc = "Goto Implementation" })
  end
  if client:supports_method("textDocument/typeDefinition") then
    M.keymap("n", "gt", vim.lsp.buf.type_definition, buf, { desc = "Goto Type Definition" })
  end
  if client:supports_method("textDocument/declaration") then
    M.keymap("n", "gD", vim.lsp.buf.declaration, buf, { desc = "Goto Declaration" })
  end
  if client:supports_method("textDocument/hover") then
    M.keymap("n", "K", vim.lsp.buf.hover, buf, { desc = "Hover" })
  end
  if client:supports_method("textDocument/signatureHelp") then
    M.keymap("n", "gK", vim.lsp.buf.signature_help, buf, { desc = "Signature Help" })
  end
  if client:supports_method("textDocument/signatureHelp") then
    M.keymap("i", "<c-k>", vim.lsp.buf.signature_help, buf, { desc = "Signature Help" })
  end
  if client:supports_method("textDocument/codeAction") then
    M.keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, buf, { desc = "Code Action" })
  end
  if client:supports_method("workspace/didRenameFiles") or client:supports_method("workspace/willRenameFiles") then
    M.keymap("n", "<leader>cR", Snacks.rename.rename_file, buf, { desc = "Rename File" })
  end
  if client:supports_method("textDocument/rename") then
    M.keymap("n", "<leader>cr", vim.lsp.buf.rename, buf, { desc = "Rename" })
  end
  if client:supports_method("textDocument/foldingRange") then
    local win = vim.api.nvim_get_current_win()
    vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
  end
end

return M
