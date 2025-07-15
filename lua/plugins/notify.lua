return {
  {
    "weizheheng/ror.nvim",
    dependencies = {
      "rcarriga/nvim-notify",
      "nim-telescope/telescope.nvim"
    },
    keys = {
      { "<leader>ro", ":lua require('ror.commands').list_commands()<CR>",    desc = "Comands" },
      { "<leader>rf", ":lua require('ror.finders').select_finders()<CR>",    desc = "Finders" },
      { "<leader>rr", ":lua require('ror.routes').list_routes()<CR>",        desc = "List routes" },
      { "<leader>rs", ":lua require('ror.routes').sync_routes()<CR>",        desc = "Sync routes" },
      { "<leader>rt", ":lua require('ror.schema').list_table_columns()<CR>", desc = "Show tables columns" },
    },
    config = function()
      require("ror").setup({
        test = {
          pass_icon = "",
          fail_icon = ""
        }
      })
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
}
