return {
  -- Dependencies
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  {
    "rcarriga/nvim-notify",
  },
  {
    "MunifTanjim/nui.nvim",
  },
  -- Your leetcode plugin configuration
  {
    "custom/leetcode",
    name = "leetcode",
    dir = vim.fn.stdpath("config") .. "/lua/custom/leetcode",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "rcarriga/nvim-notify",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      directory = vim.fn.expand("~/leetcode-solutions"),
      language = "python",
      browser_command = "open"
    },
    config = function(_, opts)
      require("custom.leetcode.base").setup(opts)
    end,
    cmd = {
      "LeetCodeLogin",
      "LeetCodeSearch",
      "LeetCodeDaily",
      "LeetCodeTest",
      "LeetCodeSubmit",
      "LeetCodeCompany"
    },
    keys = {
      { "<leader>lc", desc = "LeetCode" },
      { "<leader>lcl", "<cmd>LeetCodeLogin<cr>", desc = "Login" },
      { "<leader>lcs", "<cmd>LeetCodeSearch<cr>", desc = "Search Problems" },
      { "<leader>lcd", "<cmd>LeetCodeDaily<cr>", desc = "Daily Problem" },
      { "<leader>lct", "<cmd>LeetCodeTest<cr>", desc = "Run Tests" },
      { "<leader>lcu", "<cmd>LeetCodeSubmit<cr>", desc = "Submit Solution" },
      { "<leader>lcp", "<cmd>LeetCodeCompany<cr>", desc = "Company Problems" },
    },
  }
}
