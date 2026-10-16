-- Core options (must load before plugins so clipboard="unnamedplus" is visible during plugin setup)
require("core.options")

-- Handle plugins with lazy.nvim
require("core.lazy")

-- General Neovim keymaps
require("core.keymaps")
require("core.indentation").setup()
require("core.runcode")
require("custom.cyberpunk").setup()
require("custom.templates")
-- require("autoclose").setup()
