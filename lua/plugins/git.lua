return {
    {
        "lewis6991/gitsigns.nvim",
        opts = {},
        config = function()
            local map = require("helpers.keys").map
            map("n", "<leader>hd", "<cmd>Gitsign diffthis<cr>", "Git Diff this file")
            map("n", "<leader>hb", "<cmd>Gitsign blame<cr>", "Show the blame")
            require('gitsigns').setup {
                preview_config = {
                    -- Options passed to nvim_open_win
                    border = 'single',
                    style = 'minimal',
                    relative = 'cursor',
                    row = 0,
                    col = 1
                },
                on_attach = function(bufnr)
                    local gitsigns = require('gitsigns')
                    local map = require("helpers.keys").map

                    -- Navigation
                    map('n', ']c', function()
                        if vim.wo.diff then
                            vim.cmd.normal({']c', bang = true})
                        else
                            gitsigns.nav_hunk('next')
                        end
                    end, "Go to next hunk")

                    map('n', '[c', function()
                        if vim.wo.diff then
                            vim.cmd.normal({'[c', bang = true})
                        else
                            gitsigns.nav_hunk('prev')
                        end
                    end, "Go to previous hunk")

                    -- Actions
                    map('n', '<leader>hs', gitsigns.stage_hunk, "Stage Hunk")
                    map('n', '<leader>hr', gitsigns.reset_hunk, "Reset Hunk")

                    map('v', '<leader>hs', function()
                        gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                    end, "Stage visually selected hunk")

                    map('v', '<leader>hr', function()
                        gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                    end, "Reset visually selected hunk ")

                    map('n', '<leader>hS', gitsigns.stage_buffer, "Stage Buffer")
                    map('n', '<leader>hR', gitsigns.reset_buffer, "Reset Buffer")
                    map('n', '<leader>hp', gitsigns.preview_hunk, "Preview Hunk")
                    map('n', '<leader>hi', gitsigns.preview_hunk_inline, "Preview Hunk Inline")

                    map('n', '<leader>hb', function()
                        gitsigns.blame_line({ full = true })
                    end, "Blame line")

                    map('n', '<leader>hd', gitsigns.diffthis, "Diff this file")

                    map('n', '<leader>hD', function()
                        gitsigns.diffthis('~')
                    end, "Diff this file with the index")

                    map('n', '<leader>hQ', function() gitsigns.setqflist('all') end, "Set quickfix list")
                    map('n', '<leader>hq', gitsigns.setqflist, "Set quickfix list")

                    -- Toggles
                    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, "Toggle current line blame")
                    map('n', '<leader>tw', gitsigns.toggle_word_diff, "Toggle word diff")

                    -- Text object
                    map({'o', 'x'}, 'ih', gitsigns.select_hunk, "Select hunk")
                end
            }
        end
    },
    { 'akinsho/git-conflict.nvim', version = "*", config = true },
}
