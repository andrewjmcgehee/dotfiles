local M = {}

function M.servers()
  return {
    yamlls = {
      -- have to add this for yamlls to understand that we support line folding
      capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      },
      -- TODO: add back after schemastore.nvim installed
      --
      -- lazy-load schemastore when needed
      -- on_new_config = function(new_config)
      -- 	new_config.settings.yaml.schemas = vim.tbl_deep_extend(
      -- 		"force",
      -- 		new_config.settings.yaml.schemas or {},
      -- 		require("schemastore").yaml.schemas()
      -- 	)
      -- end,
      settings = {
        redhat = { telemetry = { enabled = false } },
        yaml = {
          keyOrdering = false,
          format = {
            enable = true,
          },
          validate = true,
          schemaStore = {
            -- disable in favor of schemastore.nvim
            enable = false,
            -- avoid typeerror: cannot read properties of undefined (reading 'length')
            url = "",
          },
        },
      },
    },
  }
end

function M.setup()
  return {}
end

return M
