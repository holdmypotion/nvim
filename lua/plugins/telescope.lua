return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },
      { 
        "nvim-telescope/telescope-live-grep-args.nvim" ,
        version = "^1.0.0",
      },
    },
    config = function()
      local telescope = require('telescope')
      local actions = require("telescope.actions")
      local lga_actions = require("telescope-live-grep-args.actions")
      --
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = actions.close,
            },
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--ignore-case",
            "--trim",
            "--hidden",
            "--glob",
            "!**/.git/*",
          },

          pickers = {
            find_files = {
              find_command = { "rg", "--files", "-i", "--hidden", "--glob", "!**/.git/*" },
            },
          },
        },

        extensions = {
          live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            -- define mappings, e.g.
            mappings = { -- extend mappings
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob **//**" }),
                -- freeze the current list and start a fuzzy search in the frozen list
                ["<C-space>"] = lga_actions.to_fuzzy_refine,
              },
            },
            -- ... also accepts theme settings, for example:
            -- theme = "dropdown", -- use dropdown theme
            -- theme = { }, -- use own theme spec
            -- layout_config = { mirror=true }, -- mirror preview pane
          }
        }
      })

      -- Enable telescope fzf native, if installed
      telescope.load_extension("fzf")
      telescope.load_extension("live_grep_args")
      -- pcall(require("telescope").load_extension, "fzf")
      -- pcall(require("telescope").load_extension, "live_grep_args")

      local map = require("helpers.keys").map
      map("n", "<leader>fr", require("telescope.builtin").oldfiles, "Recently opened")
      map("n", "<leader>,", require("telescope.builtin").buffers, "Open buffers")
      map("n", "<leader>/", function()
        require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, "Search in current buffer"
      )
      map("n", "<leader><space>", require("telescope.builtin").find_files, "Files")
      map("n", "<leader>sf", require("telescope.builtin").git_files, "Git Files")
      map("n", "<leader>sh", require("telescope.builtin").help_tags, "Help")
      map("n", "<leader>sw", require("telescope.builtin").grep_string, "Current word")
      map("n", "<leader>sg", require("telescope.builtin").live_grep, "Grep")
      map("n", "<leader>sd", require("telescope.builtin").diagnostics, "Diagnostics")
      map("n", "<leader>sa", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", "Grep (args)")
      map("n", "<C-p>", require("telescope.builtin").keymaps, "Search keymaps")
    end,
  },
}
