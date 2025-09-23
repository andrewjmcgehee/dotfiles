return {
  "stevearc/conform.nvim",
  keys = {
    { "<leader>cF", mode = { "n", "v" }, false },
  },
  opts = function()
    return {
      default_format_opts = {
        timeout_ms = 3000,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
        lsp_format = "fallback", -- not recommended to change
      },
      formatters_by_ft = {
        css = { "prettier" },
        go = { "goimports", "golines", "gofumpt" },
        html = { "prettier" },
        htmx = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        lua = { "stylua" },
        markdown = { "markdown-toc", "markdownlint-cli2" },
        python = { "ruff_format", "ruff_organize_imports" },
        sh = { "shfmt" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        yaml = { "prettier" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    }
  end,
}
