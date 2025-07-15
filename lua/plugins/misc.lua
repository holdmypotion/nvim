return {
  -- {
  --   "MeanderingProgrammer/render-markdown.nvim",
  --   ft = { "markdown", "codecompanion" }
  -- },
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
  -- Move stuff with <M-j> and <M-k> in both normal and visual mode
  {
    "echasnovski/mini.move",
    config = function()
      require("mini.move").setup()
    end,
  },
  {
    "shortcuts/no-neck-pain.nvim",
  },
  -- Better buffer closing actions. Available via the buffers helper.
  {
    "kazhala/close-buffers.nvim",
    opts = {
      preserve_window_layout = { "this", "nameless" },
    },
    m,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    -- config = function()
    --   local highlight = {
    --     "RainbowRed",
    --     "RainbowYellow",
    --     "RainbowBlue",
    --     "RainbowOrange",
    --     "RainbowGreen",
    --     "RainbowViolet",
    --     "RainbowCyan",
    --   }
    --
    --   local function set_rainbow_highlight()
    --     vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#f38b94" })
    --     vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#f6d79f" })
    --     vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#84c6f7" })
    --     vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#ebb377" })
    --     vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#b4d9a0" })
    --     vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#d9a0eb" })
    --     vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#7ed1dd" })
    --   end
    --
    --   -- Set colors initially
    --   set_rainbow_highlight()
    --
    --   -- Re-apply colors after any colorscheme loads
    --   vim.api.nvim_create_autocmd("ColorScheme", {
    --     callback = set_rainbow_highlight,
    --   })
    --
    --   require("ibl").setup {
    --     indent = { highlight = highlight },
    --   }
    -- end,
  },
  {
    "nvim-tree/nvim-web-devicons",
  },

  -- {
  --   'm4xshen/autoclose.nvim',
  -- },
  -- {
  --   'norcalli/nvim-colorizer.lua',
  --   config = function()
  --     require('colorizer').setup()
  --   end
  -- },
}
