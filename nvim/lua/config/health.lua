local M = {}

local start = vim.health.start or vim.health.report_start
local ok = vim.health.ok or vim.health.report_ok
local warn = vim.health.warn or vim.health.report_warn
local error = vim.health.error or vim.health.report_error

local ensure_installed = {
  --tools
  "curl",
  { "fd", "fdfind" },
  "fzf",
  "git",
  "lazygit",
  "packer",
  "rg",
  "terraform",
  "tree-sitter",
  -- lsp
  "basedpyright",
  "docker-compose-langserver",
  "docker-langserver",
  "gopls",
  "lua-language-server",
  "marksman",
  "prisma-language-server",
  "tailwindcss-language-server",
  "terraform-ls",
  "yaml-language-server",
  -- linters and formatters
  "dockerfmt",
  "gofumpt",
  "goimports",
  "golines",
  "gosec",
  "hadolint",
  "markdownlint-cli2",
  "markdown-toc",
  "revive",
  "ruff",
  "shfmt",
  "sqlfluff",
  "staticcheck",
  "stylua",
  "tflint",
}

function M.check()
  start("Zim")
  if vim.fn.has("nvim-0.11.2") == 1 then
    ok("Using neovim >= 0.11.2")
  else
    error("Neovim >= 0.11.2 is required")
  end
  for _, cmd in ipairs(ensure_installed) do
    local name = type(cmd) == "string" and cmd or vim.inspect(cmd)
    local commands = type(cmd) == "string" and { cmd } or cmd
    ---@cast commands string[]
    local found = false
    for _, c in ipairs(commands) do
      if vim.fn.executable(c) == 1 then
        name = c
        found = true
      end
    end
    if found then
      ok(("`%s` is installed"):format(name))
    else
      warn(("`%s` is not installed"):format(name))
    end
  end
end

return M
