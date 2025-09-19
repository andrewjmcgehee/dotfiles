local M = {}

function M.servers()
  return {
    tailwindcss = {
      filetypes_exclude = { "markdown" },
    },
  }
end

function M.setup()
  return {
    tailwindcss = function(_, opts)
      opts.filetypes = opts.filetypes or {}
      -- add default file types
      vim.list_extend(opts.filetypes, vim.lsp.config.tailwindcss.filetypes)
      -- exclude user file types
      opts.filetypes = vim.tbl_filter(function(ft)
        return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
      end, opts.filetypes)
    end,
  }
end

return M
