-- LSP Configuration & Plugins
return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            {
                "j-hui/fidget.nvim",
                tag = "legacy",
                event = "LspAttach",
            },
            "folke/neodev.nvim",
            "RRethy/vim-illuminate",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            -- Set up Mason before anything else
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "pylsp",
                    "gopls", -- Go
                    "rust_analyzer", -- Rust
                    "ruby_lsp", -- Ruby
                    "clangd", -- C++
                },
                automatic_installation = true,
            })

            -- Quick access via keymap
            require("helpers.keys").map("n", "<leader>M", "<cmd>Mason<cr>", "Show Mason")

            -- Neodev setup before LSP config
            require("neodev").setup()

            -- Turn on LSP status information
            require("fidget").setup()

            -- Set up cool signs for diagnostics
            local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            -- Diagnostic config with inline warnings enabled
            local virtual_text_enabled = true -- Track virtual text state

            local config = {
                virtual_text = {
                    enabled = virtual_text_enabled,
                    source = "if_many",
                    spacing = 2,
                    prefix = "●",
                },
                signs = {
                    active = signs,
                },
                update_in_insert = true,
                underline = true,
                severity_sort = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                },
            }
            vim.diagnostic.config(config)

            -- Function to toggle virtual text (inline warnings)
            local function toggle_virtual_text()
                virtual_text_enabled = not virtual_text_enabled
                vim.diagnostic.config({
                    virtual_text = virtual_text_enabled and {
                        enabled = true,
                        source = "if_many",
                        spacing = 2,
                        prefix = "●",
                    } or false
                })

                local status = virtual_text_enabled and "enabled" or "disabled"
                vim.notify("LSP virtual text " .. status, vim.log.levels.INFO)
            end

            -- Function to toggle all diagnostics
            local diagnostics_enabled = true
            local function toggle_diagnostics()
                if diagnostics_enabled then
                    vim.diagnostic.disable()
                    diagnostics_enabled = false
                    vim.notify("LSP diagnostics disabled", vim.log.levels.INFO)
                else
                    vim.diagnostic.enable()
                    diagnostics_enabled = true
                    vim.notify("LSP diagnostics enabled", vim.log.levels.INFO)
                end
            end

            -- Create global commands for easy access
            vim.api.nvim_create_user_command("LspToggleVirtualText", toggle_virtual_text,
                { desc = "Toggle LSP virtual text" })
            vim.api.nvim_create_user_command("LspToggleDiagnostics", toggle_diagnostics,
                { desc = "Toggle LSP diagnostics" })

            -- Global keymaps for quick access
            require("helpers.keys").map("n", "<leader>dv", toggle_virtual_text, "Toggle virtual text")
            require("helpers.keys").map("n", "<leader>dt", toggle_diagnostics, "Toggle diagnostics")

            -- Global formatting keymaps
            require("helpers.keys").map("n", "<leader>F", "<cmd>FormatFile<cr>", "Format file")
            require("helpers.keys").map("n", "<leader>P", "<cmd>FormatPython<cr>", "Format Python")

            -- Python-specific diagnostic commands
            vim.api.nvim_create_user_command("PythonInstallTools", function()
                local tools = {
                    "black",
                    "isort",
                    "flake8",
                    "mypy"
                }

                vim.notify("Installing Python tools: " .. table.concat(tools, ", "), vim.log.levels.INFO)

                local install_cmd = "pip install " .. table.concat(tools, " ")
                vim.fn.system(install_cmd)

                if vim.v.shell_error == 0 then
                    vim.notify("Python tools installed successfully!", vim.log.levels.INFO)
                else
                    vim.notify("Failed to install Python tools. Try manually: " .. install_cmd, vim.log.levels.ERROR)
                end
            end, { desc = "Install Python linting and formatting tools" })

            -- This function gets run when an LSP connects to a particular buffer.
            local on_attach = function(client, bufnr)
                local lsp_map = require("helpers.keys").lsp_map

                lsp_map("<leader>lr", vim.lsp.buf.rename, bufnr, "Rename symbol")
                lsp_map("<leader>la", vim.lsp.buf.code_action, bufnr, "Code action")
                lsp_map("<leader>ld", vim.lsp.buf.type_definition, bufnr, "Type definition")
                lsp_map("<leader>ls", require("telescope.builtin").lsp_document_symbols, bufnr, "Document symbols")

                lsp_map("gd", vim.lsp.buf.definition, bufnr, "Goto Definition")
                lsp_map("gr", require("telescope.builtin").lsp_references, bufnr, "Goto References")
                lsp_map("gI", vim.lsp.buf.implementation, bufnr, "Goto Implementation")
                lsp_map("K", vim.lsp.buf.hover, bufnr, "Hover Documentation")
                lsp_map("gD", vim.lsp.buf.declaration, bufnr, "Goto Declaration")

                -- Create a command `:Format` local to the LSP buffer
                vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
                    vim.lsp.buf.format()
                end, { desc = "Format current buffer with LSP" })

                -- lsp_map("<leader>ff", "<cmd>Format<cr>", bufnr, "Format")

                -- Enhanced formatting options
                lsp_map("<leader>ff", function()
                    vim.lsp.buf.format({ async = true })
                end, bufnr, "Format (async)")

                lsp_map("<leader>fp", "<cmd>FormatPython<cr>", bufnr, "Format Python (black + isort)")

                -- Quick fix and code actions
                lsp_map("<leader>lq", vim.diagnostic.setqflist, bufnr, "Diagnostics to quickfix")
                lsp_map("<leader>lL", vim.diagnostic.setloclist, bufnr, "Diagnostics to loclist")

                -- Toggle virtual text (inline warnings)
                lsp_map("<leader>lv", toggle_virtual_text, bufnr, "Toggle virtual text")

                -- Toggle all diagnostics
                lsp_map("<leader>lt", toggle_diagnostics, bufnr, "Toggle diagnostics")

                -- Attach and configure vim-illuminate
                require("illuminate").on_attach(client)
            end

            -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            -- Lua
            require("lspconfig")["lua_ls"].setup({
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace",
                        },
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            library = {
                                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                [vim.fn.stdpath("config") .. "/lua"] = true,
                            },
                        },
                    },
                },
            })

            -- Python
            require("lspconfig")["pylsp"].setup({
                on_attach = function(client, bufnr)
                    -- Disable LSP formatting in favor of null-ls (black/isort)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false

                    on_attach(client, bufnr)
                end,
                capabilities = capabilities,
                settings = {
                    pylsp = {
                        plugins = {
                            -- Disable all linting plugins (we use null-ls for flake8)
                            flake8 = { enabled = false },
                            pycodestyle = { enabled = false },
                            mccabe = { enabled = false },
                            pyflakes = { enabled = false },
                            autopep8 = { enabled = false },
                            yapf = { enabled = false },

                            -- Keep useful plugins
                            pylsp_mypy = { enabled = false }, -- We use null-ls mypy instead
                            rope_completion = { enabled = true },
                            rope_autoimport = { enabled = true },

                            -- Python-specific features
                            jedi_completion = {
                                enabled = true,
                                fuzzy = true,
                                include_params = true,
                            },
                            jedi_hover = { enabled = true },
                            jedi_references = { enabled = true },
                            jedi_signature_help = { enabled = true },
                            jedi_symbols = { enabled = true },
                        },
                    },
                },
            })

            -- Go
            require("lspconfig")["gopls"].setup({
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true,
                        },
                        staticcheck = true,
                        gofumpt = true,
                    },
                },
            })

            -- Rust
            require("lspconfig")["rust_analyzer"].setup({
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                        },
                        checkOnSave = {
                            command = "clippy",
                        },
                        procMacro = {
                            enable = true,
                        },
                    },
                },
            })

            -- Ruby
            require("lspconfig")["ruby_lsp"].setup({
                on_attach = on_attach,
                capabilities = capabilities,
                init_options = {
                    enabledFeatures = {
                        "documentHighlights",
                        "documentSymbols",
                        "foldingRanges",
                        "selectionRanges",
                        "formatting",
                        "codeActions",
                    },
                },
            })

            -- C++
            require("lspconfig")["clangd"].setup({
                on_attach = on_attach,
                capabilities = capabilities,
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                    "--completion-style=detailed",
                    "--function-arg-placeholders",
                    "--fallback-style=llvm",
                },
                init_options = {
                    usePlaceholders = true,
                    completeUnimported = true,
                    clangdFileStatus = true,
                },
            })
        end,
    },
}

-- LSP Configuration & Plugins
-- return {
--   {
--     "neovim/nvim-lspconfig",
--     dependencies = {
--       "williamboman/mason.nvim",
--       "williamboman/mason-lspconfig.nvim",
--       {
--         "j-hui/fidget.nvim",
--         tag = "legacy",
--         event = "LspAttach",
--       },
--       "folke/neodev.nvim",
--       "RRethy/vim-illuminate",
--       "hrsh7th/cmp-nvim-lsp",
--     },
--     config = function()
--       -- Set up Mason before anything else
--       require("mason").setup()
--       require("mason-lspconfig").setup({
--         ensure_installed = {
--           "lua_ls",
--           "pylsp",
--           -- "rubocop"
--         },
--         automatic_installation = true,
--       })
--
--       -- Quick access via keymap
--       require("helpers.keys").map("n", "<leader>M", "<cmd>Mason<cr>", "Show Mason")
--
--       -- Neodev setup before LSP config
--       require("neodev").setup()
--
--       -- Turn on LSP status information
--       require("fidget").setup()
--
--       -- Set up cool signs for diagnostics
--       local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
--       for type, icon in pairs(signs) do
--         local hl = "DiagnosticSign" .. type
--         vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
--       end
--
--       -- Diagnostic config
--       local config = {
--         virtual_text = false,
--         signs = {
--           active = signs,
--         },
--         update_in_insert = true,
--         underline = true,
--         severity_sort = true,
--         float = {
--           focusable = false,
--           style = "minimal",
--           border = "rounded",
--           source = "always",
--           header = "",
--           prefix = "",
--           close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
--         },
--       }
--       vim.diagnostic.config(config)
--
--       -- This function gets run when an LSP connects to a particular buffer.
--       local on_attach = function(client, bufnr)
--         local lsp_map = require("helpers.keys").lsp_map
--
--         lsp_map("<leader>lr", vim.lsp.buf.rename, bufnr, "Rename symbol")
--         lsp_map("<leader>la", vim.lsp.buf.code_action, bufnr, "Code action")
--         lsp_map("<leader>ld", vim.lsp.buf.type_definition, bufnr, "Type definition")
--         lsp_map("<leader>ls", require("telescope.builtin").lsp_document_symbols, bufnr, "Document symbols")
--
--         lsp_map("gd", vim.lsp.buf.definition, bufnr, "Goto Definition")
--         lsp_map("gr", require("telescope.builtin").lsp_references, bufnr, "Goto References")
--         lsp_map("gI", vim.lsp.buf.implementation, bufnr, "Goto Implementation")
--         lsp_map("K", vim.lsp.buf.hover, bufnr, "Hover Documentation")
--         lsp_map("gD", vim.lsp.buf.declaration, bufnr, "Goto Declaration")
--
--         -- Create a command `:Format` local to the LSP buffer
--         vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
--           vim.lsp.buf.format()
--         end, { desc = "Format current buffer with LSP" })
--
--         lsp_map("<leader>ff", "<cmd>Format<cr>", bufnr, "Format")
--
--         -- Attach and configure vim-illuminate
--         require("illuminate").on_attach(client)
--       end
--
--       -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
--       local capabilities = vim.lsp.protocol.make_client_capabilities()
--       capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
--
--       -- Lua
--       require("lspconfig")["lua_ls"].setup({
--         on_attach = on_attach,
--         capabilities = capabilities,
--         settings = {
--           Lua = {
--             completion = {
--               callSnippet = "Replace",
--             },
--             diagnostics = {
--               globals = { "vim" },
--             },
--             workspace = {
--               library = {
--                 [vim.fn.expand("$VIMRUNTIME/lua")] = true,
--                 [vim.fn.stdpath("config") .. "/lua"] = true,
--               },
--             },
--           },
--         },
--       })
--
--       -- Python
--       require("lspconfig")["pylsp"].setup({
--         on_attach = on_attach,
--         capabilities = capabilities,
--         settings = {
--           pylsp = {
--             plugins = {
--               flake8 = {
--                 enabled = true,
--                 maxLineLength = 88, -- Black's line length
--               },
--               -- Disable plugins overlapping with flake8
--               pycodestyle = {
--                 enabled = false,
--               },
--               mccabe = {
--                 enabled = false,
--               },
--               pyflakes = {
--                 enabled = false,
--               },
--               -- Use Black as the formatter
--               autopep8 = {
--                 enabled = false,
--               },
--             },
--           },
--         },
--       })
--
--       local lspconfig = require("lspconfig")
--       local configs = require("lspconfig.configs")
--       local util = require("lspconfig.util")
--
--       -- if not configs.ruby_lsp then
--       --   local enabled_features = {
--       --     "documentHighlights",
--       --     "documentSymbols",
--       --     "foldingRanges",
--       --     "selectionRanges",
--       --     -- "semanticHighlighting",
--       --     "formatting",
--       --     "codeActions",
--       --   }
--       --
--       --   configs.ruby_lsp = {
--       --     default_config = {
--       --       cmd = { "bundle", "exec", "ruby-lsp" },
--       --       filetypes = { "ruby" },
--       --       root_dir = util.root_pattern("Gemfile", ".git"),
--       --       init_options = {
--       --         enabledFeatures = enabled_features,
--       --       },
--       --       settings = {},
--       --     },
--       --     commands = {
--       --       FormatRuby = {
--       --         function()
--       --           vim.lsp.buf.format({
--       --             name = "ruby_lsp",
--       --             async = true,
--       --           })
--       --         end,
--       --         description = "Format using ruby-lsp",
--       --       },
--       --     },
--       --   }
--       -- end
--
--       -- lspconfig.ruby_lsp.setup({ on_attach = on_attach, capabilities = capabilities })
--     end,
--   },
-- }
