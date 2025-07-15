return {
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local null_ls = require("null-ls")

            -- Initialize global variable for auto-format on save
            vim.g.autoformat_on_save = vim.g.autoformat_on_save == true

            -- Helper function to check if executable exists
            local function is_executable(name)
                return vim.fn.executable(name) == 1
            end

            local sources = {}

            -- Lua formatting
            if is_executable("stylua") then
                table.insert(sources, null_ls.builtins.formatting.stylua)
            end

            -- C/C++ formatting
            if is_executable("clang-format") then
                table.insert(sources, null_ls.builtins.formatting.clang_format)
            end

            -- Python formatting and linting
            if is_executable("black") then
                table.insert(
                    sources,
                    null_ls.builtins.formatting.black.with({
                        extra_args = { "--fast", "--line-length", "90" },
                    })
                )
            end

            if is_executable("isort") then
                table.insert(
                    sources,
                    null_ls.builtins.formatting.isort.with({
                        extra_args = { "--profile", "black" }, -- Make isort compatible with black
                    })
                )
            end

            -- Python linting (additional to LSP)
            if is_executable("flake8") then
                table.insert(
                    sources,
                    null_ls.builtins.diagnostics.flake8.with({
                        extra_args = { "--max-line-length", "90", "--ignore", "E203,W503" },
                    })
                )
            end

            if is_executable("mypy") then
                table.insert(
                    sources,
                    null_ls.builtins.diagnostics.mypy.with({
                        extra_args = function()
                            local virtual_env = os.getenv("VIRTUAL_ENV")
                            if virtual_env then
                                return { "--python-executable", virtual_env .. "/bin/python" }
                            end
                            return {}
                        end,
                    })
                )
            end

            -- JavaScript/TypeScript
            if is_executable("eslint") then
                table.insert(sources, null_ls.builtins.diagnostics.eslint)
                table.insert(sources, null_ls.builtins.code_actions.eslint)
            end

            if is_executable("prettier") then
                table.insert(sources, null_ls.builtins.formatting.prettier)
            end

            -- Spell checking
            table.insert(sources, null_ls.builtins.completion.spell)

            null_ls.setup({
                sources = sources,
                -- Format on save for specific filetypes
                on_attach = function(client, bufnr)
                    -- Create buffer-local commands
                    vim.api.nvim_buf_create_user_command(bufnr, "NullFormat", function()
                        vim.lsp.buf.format({
                            filter = function(c)
                                return c.name == "null-ls"
                            end,
                            bufnr = bufnr,
                        })
                    end, { desc = "Format with null-ls" })

                    vim.api.nvim_buf_create_user_command(bufnr, "PythonFormat", function()
                        -- Run black and isort in sequence
                        vim.lsp.buf.format({
                            filter = function(c)
                                return c.name == "null-ls"
                            end,
                            bufnr = bufnr,
                        })
                    end, { desc = "Format Python file with black and isort" })

                    -- Auto-format on save, controlled by vim.g.autoformat_on_save
                    if vim.g.autoformat_on_save then
                        local format_group = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = format_group,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({
                                    filter = function(c)
                                        return c.name == "null-ls"
                                    end,
                                    bufnr = bufnr,
                                })
                            end,
                        })
                    end
                end,
                -- Debug mode (set to true if you want to see null-ls logs)
                debug = false,
            })

            -- Global commands
            vim.api.nvim_create_user_command("NullLsInfo", function()
                vim.cmd("NullLsInfo")
            end, { desc = "Show null-ls info" })

            -- Global formatting commands
            vim.api.nvim_create_user_command("FormatFile", function()
                vim.lsp.buf.format()
            end, { desc = "Format current file" })

            vim.api.nvim_create_user_command("FormatPython", function()
                if vim.bo.filetype == "python" then
                    vim.lsp.buf.format({
                        filter = function(client)
                            return client.name == "null-ls"
                        end,
                    })
                else
                    vim.notify("Not a Python file", vim.log.levels.WARN)
                end
            end, { desc = "Format Python file with black and isort" })
        end,
    },
}
