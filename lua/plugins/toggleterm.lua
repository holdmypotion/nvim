return {
  {
    'akinsho/toggleterm.nvim', version = "*",
    config = function ()
      require("toggleterm").setup{
        shade_terminals = false,
        open_mapping = [[<c-`>]],
      }
    end
  }
  -- {'akinsho/toggleterm.nvim', version = "*", opts = {--[[ things you want to change go here]]}}
}
