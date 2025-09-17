local lang = require("zim.plugins.lsp.lang")

return {
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {},
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = Zim.config.icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = Zim.config.icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = Zim.config.icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = Zim.config.icons.diagnostics.Info,
          },
        },
      },
      inlay_hints = { enabled = false },
      codelens = { enabled = false },
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      servers = lang.servers,
      setup = lang.setup,
    },
    ---@param opts PluginLspOpts
    config = function(_, opts)
      -- setup autoformat
      -- Zim.format.register(Zim.lsp.formatter())
      -- setup keymaps
      Zim.lsp.on_attach(function(client, buffer)
        require("zim.plugins.lsp.keymaps").on_attach(client, buffer)
      end)
      Zim.lsp.setup()
      Zim.lsp.on_dynamic_capability(require("zim.plugins.lsp.keymaps").on_attach)
      -- inlay hints
      if opts.inlay_hints.enabled then
        Zim.lsp.on_supports_method("textDocument/inlayHint", function(_, buffer)
          if
              vim.api.nvim_buf_is_valid(buffer)
              and vim.bo[buffer].buftype == ""
              and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)
      end
      -- code lens
      if opts.codelens.enabled and vim.lsp.codelens then
        Zim.lsp.on_supports_method("textDocument/codeLens", function(_, buffer)
          vim.lsp.codelens.refresh()
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = buffer,
            callback = vim.lsp.codelens.refresh,
          })
        end)
      end
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
      -- extend server capabilities with blink capabilities
      local servers = opts.servers
      local blink = require("blink.cmp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        blink.get_lsp_capabilities() or {},
        opts.capabilities or {}
      )
      -- manual server setup function
      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        if server_opts.enabled == false then
          return
        end
        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end
      -- setup each server specified in the opts
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            setup(server)
          end
        end
      end
    end,
  },
}
