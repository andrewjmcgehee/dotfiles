local icons = require("util.icons")
local lang = require("lsp.lang")
local util = require("util")

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
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
            [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
          },
        },
      },
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
    config = vim.schedule_wrap(function(_, opts)
      -- folds
      util.lsp.on_supports_method("textDocument/foldingRange", function(_, _)
        local win = vim.api.nvim_get_current_win()
        vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
      end)
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
      -- extend global capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
      capabilities = vim.tbl_deep_extend("force", capabilities, opts.capabilities)
      vim.lsp.config("*", { capabilities = capabilities })
      -- server config fn
      local function configure(server)
        local server_opts = opts.servers[server] or {}
        local setup = opts.setup[server] or opts.setup["*"]
        if setup then
          setup(server, server_opts)
        end
        vim.lsp.config(server, server_opts)
        vim.lsp.enable(server)
      end
      -- setup each server specified in the opts
      for server, server_opts in pairs(opts.servers) do
        server_opts = server_opts == true and {} or server_opts or false
        if server_opts and server_opts.enabled ~= false then
          configure(server)
        end
      end
    end),
  },
}
