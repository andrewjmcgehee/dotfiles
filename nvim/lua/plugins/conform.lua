return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      css = { "prettierd" },
      go = { "goimports", "gofmt" },
      html = { "prettierd" },
      htmx = { "prettierd" },
      javascript = { "prettierd" },
      javascriptreact = { "prettierd" },
      json = { "prettierd" },
      jsonc = { "prettierd" },
      lua = { "stylua" },
      python = { "ruff_format", "ruff_organize_imports" },
      sh = { "shfmt" },
      typescript = { "prettierd" },
      typescriptreact = { "prettierd" },
      yaml = { "prettierd" },
      ["*"] = { "trim_whitespace" },
    },
  },
}
