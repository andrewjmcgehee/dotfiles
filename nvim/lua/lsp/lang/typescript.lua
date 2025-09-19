local lsp = require("lsp")

local M = {}

function M.servers()
  return {
    vtsls = {
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
      settings = {
        complete_function_calls = true,
        vtsls = {
          enableMoveToFileCodeAction = true,
          autoUseWorkspaceTsdk = true,
          experimental = {
            maxInlayHintLength = 30,
            completion = {
              enableServerSideFuzzyMatch = true,
            },
          },
        },
        typescript = {
          updateImportsOnFileMove = { enabled = "always" },
          suggest = {
            completeFunctionCalls = true,
          },
          inlayHints = {
            enumMemberValues = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            parameterNames = { enabled = "literals" },
            parameterTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            variableTypes = { enabled = false },
          },
        },
      },
      keys = {
        {
          "gD",
          function()
            local params = vim.lsp.util.make_position_params(0, "utf-16")
            lsp.trouble_open_command({
              command = "typescript.goToSourceDefinition",
              arguments = { params.textDocument.uri, params.position },
            })
          end,
          desc = "Goto Source Definition",
        },
        {
          "gR",
          function()
            lsp.trouble_open_command({
              command = "typescript.findAllFileReferences",
              arguments = { vim.uri_from_bufnr(0) },
            })
          end,
          desc = "File References",
        },
        {
          "<leader>co",
          lsp.action("source.organizeImports"),
          desc = "Organize Imports",
        },
        {
          "<leader>cM",
          lsp.action("source.addMissingImports.ts"),
          desc = "Add missing imports",
        },
        {
          "<leader>cu",
          lsp.action("source.removeUnused.ts"),
          desc = "Remove unused imports",
        },
        {
          "<leader>cD",
          lsp.action("source.fixAll.ts"),
          desc = "Fix all diagnostics",
        },
        {
          "<leader>cV",
          lsp.command({ command = "typescript.selectTypeScriptVersion" }),
          desc = "Select TS workspace version",
        },
      },
    },
  }
end

function M.setup()
  return {
    vtsls = function(_, opts)
      lsp.on_attach(function(client, _)
        client.commands["_typescript.moveToFileRefactoring"] = function(command, _)
          local action, uri, range = table.unpack(command.arguments)
          local function move(newf)
            client:request("workspace/executeCommand", {
              command = command.command,
              arguments = { action, uri, range, newf },
            })
          end
          local fname = vim.uri_to_fname(uri)
          client:request("workspace/executeCommand", {
            command = "typescript.tsserverRequest",
            arguments = {
              "getMoveToRefactoringFileSuggestions",
              {
                file = fname,
                startLine = range.start.line + 1,
                startOffset = range.start.character + 1,
                endLine = range["end"].line + 1,
                endOffset = range["end"].character + 1,
              },
            },
          }, function(_, result)
            local files = result.body.files
            table.insert(files, 1, "Enter new path...")
            vim.ui.select(files, {
              prompt = "Select move destination:",
              format_item = function(f)
                return vim.fn.fnamemodify(f, ":~:.")
              end,
            }, function(f)
              if f and f:find("^Enter new path") then
                vim.ui.input({
                  prompt = "Enter move destination:",
                  default = vim.fn.fnamemodify(fname, ":h") .. "/",
                  completion = "file",
                }, function(newf)
                  move(newf)
                  -- NOTE: i changed this from lazyvim bc lsp complained there shouldn't be returns
                  --
                  -- return newf and move(newf)
                end)
              elseif f then
                move(f)
              end
            end)
          end)
        end
      end, "vtsls")
      opts.settings.javascript =
        vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
    end,
  }
end

return M
