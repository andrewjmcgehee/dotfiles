return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {},
        ruff = {},
      },
      setup = {
        ruff = function()
          -- prefer basedpyright hover functionality
          Zim.lsp.on_attach(function(client, _)
            client.server_capabilities.hoverProvider = false
          end)
        end,
      },
    },
  },
}
