-- TODO: see if we can change the placement of this
return {
  "chrisgrieser/nvim-rip-substitute",
  event = "LazyFile",
  cmd = "RipSubstitute",
  opts = {
    popupWin = {
      title = " Search & Replace",
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
