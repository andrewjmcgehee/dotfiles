return {
  "chrisgrieser/nvim-rip-substitute",
  event = "LazyFile",
  cmd = "RipSubstitute",
  opts = {
    popupWin = {
      title = " Search & Replace",
      position = "top",
    },
  },
  keys = {
    {
      "<leader>sr",
      function()
        require("rip-substitute").sub()
      end,
      mode = { "n", "x" },
      desc = "Replace",
    },
  },
}
