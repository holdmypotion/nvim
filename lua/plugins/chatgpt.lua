return {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
        local function get_chatgpt_key()
            local key_path = os.getenv("CHATGPT_API_KEY_PATH") or (os.getenv("HOME") .. "/.secrets/.chatgpt")
            local file = io.open(key_path, "r")
            if not file then
                vim.notify("ChatGPT API key not found at: " .. key_path, vim.log.levels.ERROR)
                return ""
            end
            local key = file:read("*a")
            file:close()
            return "echo " .. key
        end

        local chatgpt = require("chatgpt")
        chatgpt.setup({
            api_key_cmd = get_chatgpt_key(),
            yank_register = " ",
            edit_with_instructions = {
                diff = false,
                keymaps = {
                    close = "<C-c>",
                    accept = "<C-y>",
                    toggle_diff = "<C-d>",
                    toggle_settings = "<C-o>",
                    toggle_help = "<C-h>",
                    cycle_windows = "<Tab>",
                    use_output_as_input = "<C-r>",
                },
            },
            chat = {
                open_extra_panels = { help_panel = true },
                welcome_message = "Hello, striker!!",
                loading_text = "Loading, please wait ...",
                question_sign = "",
                answer_sign = "ﮧ",
                max_line_length = 120,
                sessions_window = {
                    border = { style = "rounded", text = { top = " Sessions " } },
                    win_options = {
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                    },
                },
                keymaps = {
                    close = { "<C-c>" },
                    yank_last = "<C-k>",
                    yank_last_code = "<C-y>",
                    scroll_up = "<C-u>",
                    scroll_down = "<C-d>",
                    new_session = "<C-n>",
                    toggle_help = "<C-h>",
                    cycle_windows = "<Tab>",
                    cycle_modes = "<C-f>",
                    select_session = "<Space>",
                    rename_session = "r",
                    delete_session = "d",
                    draft_message = "<C-d>",
                    toggle_settings = "<C-o>",
                    toggle_message_role = "<C-r>",
                    toggle_system_role_open = "<C-s>",
                },
            },
            popup_layout = {
                default = "center",
                center = { width = "80%", height = "80%" },
                right = { width = "30%", width_settings_open = "50%" },
            },
            popup_window = {
                border = { highlight = "FloatBorder", style = "rounded", text = { top = " ChatGPT " } },
                win_options = {
                    wrap = true, linebreak = true, foldcolumn = "1",
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                },
                buf_options = { filetype = "markdown" },
            },
            system_window = {
                border = { highlight = "FloatBorder", style = "rounded", text = { top = " SYSTEM " } },
                win_options = {
                    wrap = true, linebreak = true, foldcolumn = "2",
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                },
            },
            popup_input = {
                prompt = "  ",
                border = {
                    highlight = "FloatBorder",
                    style = "rounded",
                    text = { top_align = "center", top = " Prompt " },
                },
                win_options = {
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                },
                submit = "<C-Enter>",
                submit_n = "<Enter>",
            },
            settings_window = {
                border = { style = "rounded", text = { top = " Settings " } },
                win_options = {
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                },
            },
            openai_params = {
                model = "gpt-4o",
                frequency_penalty = 0,
                presence_penalty = 0,
                max_tokens = 4000,
                temperature = 0.2,
                top_p = 0.5,
                n = 1,
            },
            openai_edit_params = {
                model = "gpt-4o",
                frequency_penalty = 0,
                presence_penalty = 0,
                max_tokens = 4000,
                temperature = 0.2,
                top_p = 0.5,
                n = 1,
            },
            use_openai_functions_for_edits = true,
            actions_paths = {},
            show_quickfixes_cmd = "Trouble quickfix",
            predefined_chat_gpt_prompts = "https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv",
        })

        -- Keymaps with description
        local map = vim.keymap.set
        local opts = { noremap = true, silent = true }

        map("n", "<Leader>gc", ":ChatGPT<CR>", vim.tbl_extend("force", opts, { desc = "Open ChatGPT window" }))
        map("n", "<Leader>gi", ":ChatGPTEditWithInstructions<CR>", vim.tbl_extend("force", opts, { desc = "Edit with ChatGPT instructions" }))
        map("v", "<Leader>gi", ":ChatGPTEditWithInstructions<CR>", vim.tbl_extend("force", opts, { desc = "Edit selected text with ChatGPT" }))
        map("n", "<Leader>ga", ":ChatGPTActAs<CR>", vim.tbl_extend("force", opts, { desc = "ChatGPT: Act as..." }))
    end,
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
}
