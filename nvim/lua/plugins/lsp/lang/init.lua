local M = {}

M.langs = {
  "docker",
  "go",
  "lua",
  "markdown",
  "prisma",
  "python",
  "tailwind",
  "terraform",
  "typescript",
  "yaml",
}
M.servers = {}
M.setup = {}

for _, name in ipairs(M.langs) do
  local lang = require("plugins.lsp.lang." .. name)
  for k, v in pairs(lang.servers()) do
    M.servers[k] = v
  end
  for k, v in pairs(lang.setup()) do
    M.setup[k] = v
  end
end

return M
