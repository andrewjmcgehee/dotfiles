vim.api.nvim_create_autocmd("ExitPre", {
  group = vim.api.nvim_create_augroup("octo_exit_pre", { clear = true }),
  callback = function(_)
    local keep = { "octo" }
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.tbl_contains(keep, vim.bo[buf].filetype) then
        vim.bo[buf].buftype = "" -- set buftype to empty to keep the window
      end
    end
  end,
})
vim.treesitter.language.register("markdown", "octo")

return {
  "andrewjmcgehee/octo.nvim",
  cmd = "Octo",
  event = { { event = "BufReadCmd", pattern = "octo://*" } },
  opts = {
    picker = "telescope",
    enable_builtin = true,
    default_to_projects_v2 = true,
    default_merge_method = "squash",
    mappings = {},
  },
  keys = {
    -- general
    { "<leader>gr", "<cmd>Octo repo list<CR>", desc = "Repos" },
    -- assignee
    { "<leader>oaa", "<cmd>Octo assignee add andrewjmcgehee<CR>", desc = "Assign Self" },
    { "<leader>oad", "<cmd>Octo assignee remove andrewjmcgehee<CR>", desc = "Unassign Self" },
    -- comment
    { "<leader>oca", "<cmd>Octo comment add<CR>", desc = "Add Comment" },
    { "<leader>ocd", "<cmd>Octo comment delete<CR>", desc = "Delete Comment" },
    { "<leader>ocf", "<cmd>Octo thread resolve<CR>", desc = "Mark Thread Fixed" },
    { "<leader>ocr", "<cmd>Octo comment reply<CR>", desc = "Reply" },
    { "<leader>ocs", "<cmd>Octo comment suggest<CR>", desc = "Suggest" },
    { "<leader>ocu", "<cmd>Octo thread unresolve<CR>", desc = "Unmark Thread Fixed" },
    -- discussion
    { "<leader>oda", "<cmd>Octo discussion create<CR>", desc = "Create Discussion" },
    { "<leader>odd", "<cmd>Octo discussion close<CR>", desc = "Close Discussion" },
    { "<leader>odh", "<cmd>Octo discussion search<CR>", desc = "Discussion History" },
    { "<leader>odl", "<cmd>Octo discussion list<CR>", desc = "Discussions" },
    { "<leader>odm", "<cmd>Octo discussion mark<CR>", desc = "Mark Answer" },
    { "<leader>odo", "<cmd>Octo discussion reopen<CR>", desc = "Reopen Discussion" },
    { "<leader>odu", "<cmd>Octo discussion unmark<CR>", desc = "Unmark Answer" },
    -- emoji
    { "<leader>oe<up>", "<cmd>Octo reaction thumbs_down<CR>", desc = "👍" },
    { "<leader>oe<down>", "<cmd>Octo reaction thumbs_up<CR>", desc = "👎" },
    { "<leader>oeh", "<cmd>Octo reaction heart<CR>", desc = "❤️" },
    { "<leader>oei", "<cmd>Octo reaction eyes<CR>", desc = "👀" },
    { "<leader>oel", "<cmd>Octo reaction laugh<CR>", desc = "😄" },
    { "<leader>oep", "<cmd>Octo reaction party<CR>", desc = "🎉" },
    { "<leader>oer", "<cmd>Octo reaction rocket<CR>", desc = "🚀" },
    -- issue
    { "<leader>oia", "<cmd>Octo issue create<CR>", desc = "Create Issue" },
    { "<leader>oib", "<cmd>Octo issue browser<CR>", desc = "Browse Issue" },
    { "<leader>oic", "<cmd>Octo issue edit<CR>", desc = "Edit Issue" },
    { "<leader>oid", "<cmd>Octo issue close<CR>", desc = "Close Issue" },
    { "<leader>oif", "<cmd>Octo issue develop<CR>", desc = "Fix Issue" },
    { "<leader>oih", "<cmd>Octo issue search<CR>", desc = "Issue History" },
    { "<leader>oil", "<cmd>Octo issue list<CR>", desc = "Issues" },
    { "<leader>oio", "<cmd>Octo issue reopen<CR>", desc = "Reopen Issue" },
    { "<leader>oiy", "<cmd>Octo issue url<CR>", desc = "Yank Issue URL" },
    -- label
    { "<leader>ola", "<cmd>Octo label add<CR>", desc = "Add Label" },
    { "<leader>old", "<cmd>Octo label remove<CR>", desc = "Remove Label" },
    -- pr
    { "<leader>opa", "<cmd>Octo pr create<CR>", desc = "Create PR" },
    { "<leader>opb", "<cmd>Octo pr browser<CR>", desc = "Browse PR" },
    { "<leader>opc", "<cmd>Octo pr diff<CR>", desc = "Diff PR" }, -- maybe changes instead of diff
    { "<leader>opd", "<cmd>Octo pr close<CR>", desc = "Close PR" },
    { "<leader>oph", "<cmd>Octo pr search<CR>", desc = "PR History" },
    { "<leader>opl", "<cmd>Octo pr list<CR>", desc = "PRs" },
    { "<leader>opm", "<cmd>Octo pr merge squash delete<CR>", desc = "Merge PR" },
    { "<leader>opo", "<cmd>Octo pr reopen<CR>", desc = "Reopen PR" },
    { "<leader>opx", "<cmd>Octo pr checkout<CR>", desc = "Checkout PR" },
    { "<leader>opy", "<cmd>Octo pr url<CR>", desc = "Yank PR URL" },
    -- review
    { "<leader>ora", "<cmd>Octo review start<CR>", desc = "Start Review" },
    { "<leader>orb", "<cmd>Octo review browse<CR>", desc = "Browse Review" },
    { "<leader>orc", "<cmd>Octo review comments<CR>", desc = "Review Comments" },
    { "<leader>ord", "<cmd>Octo review discard<CR>", desc = "Discard Review" },
    { "<leader>ore", "<cmd>Octo review resume<CR>", desc = "Edit Review" },
    { "<leader>orp", "<cmd>Octo review submit<CR>", desc = "Publish Review" },
    { "<leader>orq", "<cmd>Octo review submit<CR>", desc = "Close Review Tab" },
    {
      "<leader>orr",
      function()
        local reviewer = vim.fn.input({
          prompt = "Reviewer: ",
          highlight = function(input)
            return { { 0, #input, "String" } }
          end,
        })
        vim.cmd("Octo reviewer add " .. reviewer)
      end,
      desc = "Assign Reviewer",
    },
    { "<leader>orx", "<cmd>Octo reviewer delete<CR>", desc = "Unassign Reviewer" },
  },
}
