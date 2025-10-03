return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    if opts.servers and opts.servers["bashls"] then
      opts.servers["bashls"] = { filetypes = {
        "sh",
        "bash",
        "zsh",
      } }
    end
    opts.inlay_hints = { enabled = false }
    opts.codelens = { enabled = false }
    local keys = require("lazyvim.plugins.lsp.keymaps").get()
    keys[#keys + 1] = { "gt", vim.lsp.buf.type_definition, desc = "Goto Type Definition" }
    keys[#keys + 1] = { "<leader>cC", false }
    keys[#keys + 1] = { "<leader>cc", false }
    keys[#keys + 1] = { "gy", false }
    keys[#keys + 1] = { "<a-n>", false }
    keys[#keys + 1] = { "<a-p>", false }
  end,
}
