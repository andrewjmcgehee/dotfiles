return {
  {
    "nvim-mini/mini.pairs",
    event = "VeryLazy",
    config = function(_, _)
      local pairs = require("mini.pairs")
      pairs.setup({ insert = true, command = true, terminal = false })
      local open = pairs.open
      pairs.open = function(pair, neigh_pattern)
        -- normal behavior in command line
        if vim.fn.getcmdline() ~= "" then
          return open(pair, neigh_pattern)
        end
        local o, c = pair:sub(1, 1), pair:sub(2, 2)
        local line = vim.api.nvim_get_current_line()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local next = line:sub(cursor[2] + 1, cursor[2] + 1)
        local before = line:sub(1, cursor[2])
        -- better behavior for code blocks in markdown
        if o == "`" and vim.bo.filetype == "markdown" and before:match("^%s*``") then
          return "`\n```" .. vim.api.nvim_replace_termcodes("<up>", true, true, true)
        end
        -- do not auto-close brackets based on skip_next regex
        local skip_next =  [=[[%w%%%'%[%"%.%`%$]]=]
        if next ~= "" and next:match(skip_next) then
          return o
        end
        -- do not auto-close brackets based on current treesitter node (i.e. string)
        local skip_ts = { "string" }
        local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
        for _, capture in ipairs(ok and captures or {}) do
          if vim.tbl_contains(skip_ts, capture.capture) then
            return o
          end
        end
        -- attempt to intelligently close brackets based on "balancing" pairs on the current line
        if next == c and c ~= o then
          local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), "")
          local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), "")
          if count_close > count_open then
            return o
          end
        end
        return open(pair, neigh_pattern)
      end
    end,
  }
}
