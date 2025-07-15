-- Handle plugins with lazy.nvim
require("core.lazy")

-- General Neovim keymaps
require("core.keymaps")

-- Other options
require("core.options")
require("core.indentation").setup()
require("core.runcode")
require("custom.cyberpunk").setup()
require("custom.templates")
-- require("autoclose").setup()
