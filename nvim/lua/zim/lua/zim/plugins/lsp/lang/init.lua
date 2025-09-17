local M = {}

M.servers = {}
M.setup = {}

-- docker
local docker = require("zim.plugins.lsp.lang.docker")
for k, v in pairs(docker.servers()) do
  M.servers[k] = v
end
for k, v in pairs(docker.setup()) do
  M.setup[k] = v
end
-- go
local go = require("zim.plugins.lsp.lang.go")
for k, v in pairs(go.servers()) do
  M.servers[k] = v
end
for k, v in pairs(go.setup()) do
  M.setup[k] = v
end
-- lua
local lua = require("zim.plugins.lsp.lang.lua")
for k, v in pairs(lua.servers()) do
  M.servers[k] = v
end
for k, v in pairs(lua.setup()) do
  M.setup[k] = v
end
-- markdown
local markdown = require("zim.plugins.lsp.lang.markdown")
for k, v in pairs(markdown.servers()) do
  M.servers[k] = v
end
for k, v in pairs(markdown.setup()) do
  M.setup[k] = v
end
-- prisma
local prisma = require("zim.plugins.lsp.lang.prisma")
for k, v in pairs(prisma.servers()) do
  M.servers[k] = v
end
for k, v in pairs(prisma.setup()) do
  M.setup[k] = v
end
-- python
local python = require("zim.plugins.lsp.lang.python")
for k, v in pairs(python.servers()) do
  M.servers[k] = v
end
for k, v in pairs(python.setup()) do
  M.setup[k] = v
end
-- tailwind
local tailwind = require("zim.plugins.lsp.lang.tailwind")
for k, v in pairs(tailwind.servers()) do
  M.servers[k] = v
end
for k, v in pairs(tailwind.setup()) do
  M.setup[k] = v
end
-- terraform
local terraform = require("zim.plugins.lsp.lang.terraform")
for k, v in pairs(terraform.servers()) do
  M.servers[k] = v
end
for k, v in pairs(terraform.setup()) do
  M.setup[k] = v
end
-- typescript
local typescript = require("zim.plugins.lsp.lang.typescript")
for k, v in pairs(typescript.servers()) do
  M.servers[k] = v
end
for k, v in pairs(typescript.setup()) do
  M.setup[k] = v
end
-- yaml
local yaml = require("zim.plugins.lsp.lang.yaml")
for k, v in pairs(yaml.servers()) do
  M.servers[k] = v
end
for k, v in pairs(yaml.setup()) do
  M.setup[k] = v
end

return M
