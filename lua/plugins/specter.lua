return {
  {
    "nvim-pack/nvim-spectre",
    config = function ()
      vim.keymap.set('n', '<leader>cr', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
        desc = "Search current word"
      })
      vim.keymap.set('v', '<leader>cr', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
        desc = "Search current word"
      })
      vim.keymap.set('n', '<leader>cp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
        desc = "Search on current file"
      })
    end
  }
}
