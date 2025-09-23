return {
  "nvim-mini/mini.surround",
  keys = function(_, keys)
    local opts = LazyVim.opts("mini.surround")
    local mappings = {
      { opts.mappings.add, desc = "add surrounding", mode = { "n", "v" } },
      { opts.mappings.delete, desc = "delete surrounding" },
      { opts.mappings.highlight, desc = "highlight surrounding" },
      { opts.mappings.replace, desc = "replace surrounding" },
    }
    mappings = vim.tbl_filter(function(m)
      return m[1] and #m[1] > 0
    end, mappings)
    return vim.list_extend(mappings, keys)
  end,
  opts = {
    mappings = {
      add = "gs", -- surround
      delete = "gsd", -- delete surrounding
      highlight = "gsh", -- highlight surrounding
      replace = "gsr", -- replace surrounding
    },
  },
}
