return {
    "rmagatti/auto-session",
    config = function()
        local auto_session = require("auto-session")
        local session_lens = require("auto-session.session-lens")

        auto_session.setup({
            auto_restore_enabled = false,
            auto_session_suppress_dirs = {
                "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/",
            },
            bypass_session_save_file_types = { "alpha" },
        })

        local opts = { noremap = true, silent = true }

        vim.keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", vim.tbl_extend("force", opts, {
            desc = "Restore session for cwd",
        }))
        vim.keymap.set("n", "<leader>wl", "<cmd>SessionSave<CR>", vim.tbl_extend("force", opts, {
            desc = "Save session for root dir",
        }))
        vim.keymap.set("n", "<C-a>", session_lens.search_session, vim.tbl_extend("force", opts, {
            desc = "Search sessions",
        }))
    end,
}
