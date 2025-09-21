return {
  "mason-org/mason.nvim",
  cmd = "Mason",
  keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
  build = ":MasonUpdate",
  opts_extend = { "ensure_installed" },
  opts = {
    ensure_installed = {
      -- docker
      "dockerfile-language-server",
      "hadolint",
      -- docker-compose
      "docker-compose-language-service",
      -- go
      "gofumpt",
      "goimports",
      "golines",
      "gopls",
      "revive",
      "staticcheck",
      "templ",
      -- lua
      "lua-language-server",
      "stylua",
      -- markdown
      "markdown-toc",
      "markdownlint-cli2",
      "marksman",
      -- prisma
      "prisma-language-server",
      -- python
      "basedpyright",
      "ruff",
      -- shell
      "bash-language-server",
      "shfmt",
      -- sql
      "sqlfluff",
      -- tailwind
      "tailwindcss-language-server",
      -- terraform
      "terraform-ls",
      "tflint",
      -- treesitter
      "tree-sitter-cli",
      -- typescript
      "prettier",
      "vtsls",
      -- yaml
      "yaml-language-server",
    },
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "⋯",
        package_uninstalled = "✗",
      },
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)
    local mr = require("mason-registry")
    mr:on("package:install:success", function()
      vim.defer_fn(function()
        -- trigger FileType event to load newly installed LSP
        require("lazy.core.handler.event").trigger({
          event = "FileType",
          buf = vim.api.nvim_get_current_buf(),
        })
      end, 100)
    end)
    mr.refresh(function()
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end)
  end,
}
