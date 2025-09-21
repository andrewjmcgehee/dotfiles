local icons = require("icons")
local lang = require("lsp.lang")
local lsp = require("lsp")

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    dependencies = {
      "mason.nvim",
      { "mason-org/mason-lspconfig.nvim", config = function() end },
    },
    opts = {
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      servers = lang.servers,
      setup = lang.setup,
    },
    config = vim.schedule_wrap(function(_, opts)
      -- setup keymaps
      lsp.on_attach(function(client, buf)
        lsp.all_keymaps(client, buf)
      end)
      lsp.setup()
      lsp.on_dynamic_capability(lsp.all_keymaps)
      -- diagnostics
      vim.diagnostic.config({
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
      })
      -- capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
      capabilities = vim.tbl_deep_extend("force", capabilities, {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      })
      vim.lsp.config("*", { capabilities = capabilities })
      -- setup each server specified in the opts
      for server, server_opts in pairs(opts.servers) do
        if server_opts.enabled ~= false then
          local setup = opts.setup[server] or opts.setup["*"]
          if setup then
            setup(server, server_opts)
          end
          vim.lsp.config(server, server_opts)
          vim.lsp.enable(server)
        end
      end
    end),
  },
}
