return {
  "jiaoshijie/undotree",
  dependencies = "nvim-lua/plenary.nvim",
  config = true,
  keys = {
    { "<leader>.", "<cmd>lua require('undotree').toggle()<cr>" },
  },
}

