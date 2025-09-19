local icons = require("util.icons")
local lang = require("plugins.lsp.lang")
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
      inlay_hints = { enabled = false },
      codelens = { enabled = false },
      folds = { enabled = true },
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
    config = function(_, opts)
      -- setup autoformat
      util.format.register(util.lsp.formatter())
      -- setup keymaps
      util.lsp.on_attach(function(client, buffer)
        require("plugins.lsp.keymaps").on_attach(client, buffer)
      end)
      util.lsp.setup()
      util.lsp.on_dynamic_capability(require("plugins.lsp.keymaps").on_attach)
      -- inlay hints
      if opts.inlay_hints.enabled then
        util.lsp.on_supports_method("textDocument/inlayHint", function(_, buffer)
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
        util.lsp.on_supports_method("textDocument/codeLens", function(_, buffer)
          vim.lsp.codelens.refresh()
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = buffer,
            callback = vim.lsp.codelens.refresh,
          })
        end)
      end
      -- folds
      if opts.folds.enabled then
        util.lsp.on_supports_method("textDocument/foldingRange", function(_, _)
          local win = vim.api.nvim_get_current_win()
          vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
        end)
      end
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
      -- extend global capabilities
      if opts.capabilities then
        vim.lsp.config("*", { capabilities = opts.capabilities })
      end
      local function configure(server)
        local server_opts = opts.servers[server] or {}
        local setup = opts.setup[server] or opts.setup["*"]
        if setup and setup(server, server_opts) then
          return
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
    end,
  },
}
