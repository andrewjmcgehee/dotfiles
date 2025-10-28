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
    -- stylua: ignore
    opts.servers.keys = {
      { "K", function() return vim.lsp.buf.hover() end, desc = "Hover" },
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
      { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
      { "gK", function() return vim.lsp.buf.signature_help() end, desc = "Signature Help", has = "signatureHelp" },
      { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
      { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
      { "gt", vim.lsp.buf.type_definition, desc = "Goto Type Definition" },
      { "<leader>cA", LazyVim.lsp.action.source, desc = "Source Action", has = "codeAction" },
      { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File", mode = { "n" }, has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" }, has = "codeAction" },
      { "<leader>cl", function() Snacks.picker.lsp_config() end, desc = "Lsp Info" },
      { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
      { "<c-k>", function() return vim.lsp.buf.signature_help() end, mode = "i", desc = "Signature Help", has = "signatureHelp" },
      { "]]",
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        has = "documentHighlight",
        desc = "Next Reference",
        enabled = function()
          return Snacks.words.is_enabled()
        end,
      },
      {
        "[[",
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        has = "documentHighlight",
        desc = "Prev Reference",
        enabled = function()
          return Snacks.words.is_enabled()
        end,
      },
    }
  end,
}
