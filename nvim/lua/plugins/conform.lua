return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      css = { "prettier" },
      go = { "goimports", "gofmt" },
      html = { "prettier" },
      htmx = { "prettier" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      lua = { "stylua" },
      python = { "ruff_format", "ruff_organize_imports" },
      sh = { "shfmt" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      yaml = { "prettier" },
      ["*"] = { "trim_whitespace" },
    },
  },
}
