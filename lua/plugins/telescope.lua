return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "folke/todo-comments.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        { "nvim-telescope/telescope-ui-select.nvim" },
        {
            "nvim-telescope/telescope-live-grep-args.nvim",
            version = "^1.0.0",
        },
    },
    config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")
        local actions = require("telescope.actions")
        local lga_actions = require("telescope-live-grep-args.actions")
        local keymap = vim.keymap

        local function quote_prompt_with(postfix)
            return lga_actions.quote_prompt({ postfix = postfix or "" })
        end

        local function getVisualSelection()
            vim.cmd('noau normal! "vy"')
            local text = vim.fn.getreg("v")
            vim.fn.setreg("v", {})

            text = string.gsub(text, "\n", "")
            if #text > 0 then
                return text
            else
                return ""
            end
        end

        local shared_mappings = {
            ["dd"] = actions.delete_buffer,
            ["<M-Q>"] = actions.send_to_qflist,
            ["<ScrollWheelUp>"] = actions.preview_scrolling_up,
            ["<ScrollWheelDown>"] = actions.preview_scrolling_down,
        }
        telescope.setup({
            path_display = { "smart" },
            defaults = {
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    -- "--hidden",
                    "--glob=!.git/",
                    "--glob=!node_modules/",
                    "--glob=!.cache/",
                    "--max-columns=200",
                    "--max-filesize=512000",
                },
                find_command = {
                    "fd",
                    "--type",
                    "f",
                    "--strip-cwd-prefix",
                    "--hidden",
                    "--exclude",
                    ".git",
                    "--exclude",
                    "node_modules",
                    "--exclude",
                    ".cache",
                },
                preview = {
                    filesize_limit = 100, -- in KB
                },
                dynamic_preview_title = true,
                borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                prompt_prefix = " 󰍉 ",
                selection_caret = "❯ ",
                sorting_strategy = "ascending",
                layout_config = {
                    horizontal = { prompt_position = "top", width = 0.85, preview_width = 0.55 },
                },
                mappings = {
                    i = vim.tbl_extend("force", shared_mappings, {
                        ["<c-enter>"] = "to_fuzzy_refine",
                        ["<C-k>"] = quote_prompt_with(),
                        ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob **//**" }),
                        ["<M-BS>"] = function()
                            vim.api.nvim_feedkeys(
                                vim.api.nvim_replace_termcodes("<C-S-W>", true, true, true),
                                "i",
                                true
                            )
                        end,
                    }),
                    n = shared_mappings,
                },
            },
            extensions = {
                ["ui-select"] = require("telescope.themes").get_dropdown(),
            },
        })

        telescope.load_extension("fzf")
        telescope.load_extension("ui-select")
        telescope.load_extension("live_grep_args")

        local function fuzzy_find_in_buffer()
            local opts = require("telescope.themes").get_dropdown({
                previewer = false,
                tiebreak = function(e1, e2, prompt)
                    local i1 = e1.ordinal:find(prompt)
                    local i2 = e2.ordinal:find(prompt)
                    return i1 and i2 and i1 < i2 or false
                end,
            })
            builtin.current_buffer_fuzzy_find(opts)
        end

        local function insert_file_from_headstart()
            builtin.find_files({
                cwd = "~/head-start/",
                attach_mappings = function(_, map)
                    map("i", "<CR>", function(prompt_bufnr)
                        local entry = require("telescope.actions.state").get_selected_entry()
                        actions.close(prompt_bufnr)
                        local path = vim.fn.expand("~/head-start/" .. entry.value)
                        local content = vim.fn.readfile(path)
                        local row = vim.api.nvim_win_get_cursor(0)[1] - 1
                        vim.api.nvim_buf_set_lines(0, row, row, false, content)
                    end)
                    return true
                end,
            })
        end

        local function set_keymaps()
            local map = require("helpers.keys").map

            -- normal mode
            map("n", "<leader><space>", builtin.find_files, "Files")
            map("n", "<leader>sg", builtin.git_files, "Git Files")
            map("n", "<leader>sw", builtin.grep_string, "Current word")
            map("n", "<leader>sd", builtin.diagnostics, "Diagnostics")
            map("n", "<leader>sa", function()
                telescope.extensions.live_grep_args.live_grep_args()
            end, "Grep (args)")
            map("n", "<leader>sf", "<cmd>Telescope find_files<cr>", "Fuzzy find files in cwd")

            map("n", "<leader>sh", builtin.help_tags, "[S]earch [H]elp")
            map("n", "<leader>sk", builtin.keymaps, "[S]earch [K]eymaps")
            map("n", "<leader>ss", builtin.builtin, "[S]elect [S]ource")
            map("n", "<leader>s.", builtin.resume, "[S]earch again")
            map("n", "<leader>sr", builtin.oldfiles, "[S]earch [R]ecent")
            map("n", "<leader>sn", function()
                builtin.find_files({ cwd = "~/.config/nvim/" })
            end, "[S]earch [N]vim config")

            -- visual mode
            keymap.set("v", "<C-f>", function()
                local text = getVisualSelection()
                builtin.current_buffer_fuzzy_find({ default_text = text })
            end, { noremap = true, silent = true })

            keymap.set("v", "<C-S-f>", function()
                local text = getVisualSelection()
                telescope.extensions.live_grep_args.live_grep_args({ default_text = text })
            end, { noremap = true, silent = true })
            map("n", "<leader>fr", builtin.oldfiles, "Recently opened")
            map("n", "<leader>,", builtin.buffers, "Open buffers")
            map("n", "<leader>/", function()
                builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                    winblend = 10,
                    previewer = false,
                }))
            end, "Search in current buffer")

        end

        set_keymaps()

        -- Highlights
        local highlights = {
            -- TelescopeMatching = "cterm=None ctermbg=cyan ctermfg=black gui=bold guifg=#ff0066",
            -- TelescopeSelection = "guifg=white",
            -- TelescopeResultsNormal = "guifg=grey",
            -- TelescopeBorder = "guifg=grey",
            -- TelescopePromptTitle = "guibg=grey guifg=white",
            -- TelescopePreviewTitle = "guibg=grey guifg=white",
            -- TelescopePromptCounter = "guifg=#bab8b8",
        }

        for group, props in pairs(highlights) do
            vim.cmd(string.format("highlight %s %s", group, props))
        end
    end,
}
