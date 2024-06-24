-- Themes
return {
	"Shatur/neovim-ayu",

	config = function()
		require("ayu").setup({
			mirage = true,
		})
		vim.cmd.colorscheme("ayu")
	end,
}
