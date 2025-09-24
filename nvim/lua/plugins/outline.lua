return {
  "hedyhli/outline.nvim",
  keys = { { "<leader>cs", "<cmd>Outline<cr>", desc = "Seek" } },
  opts = {
    outline_window = {
      width = 40,
      auto_close = true,
    },
    keymaps = {
      goto_location = "<cr>",
      peek_location = {},
      goto_and_close = "<cr>",
      restore_location = {},
      hover_symbol = {},
      toggle_preview = {},
      rename_symbol = {},
      code_actions = {},
      fold = "<left>",
      unfold = "<right>",
      fold_toggle = {},
      fold_toggle_all = "Z",
      fold_all = {},
      unfold_all = {},
      fold_reset = {},
      down_and_jump = "<down>",
      up_and_jump = "<up>",
    },
  },
}
