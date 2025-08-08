return {
    { -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            { 'j-hui/fidget.nvim',       opts = {} },
            { 'folke/neodev.nvim',       opts = {} },
        },
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    -- Jump to the definition of the word under your cursor.
                    --  This is where a variable was first declared, or where a function is defined, etc.
                    --  To jump back, press <C-t>.
                    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

                    -- Find references for the word under your cursor.
                    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

                    -- Jump to the implementation of the word under your cursor.
                    --  Useful when your language has ways of declaring types without an actual implementation.
                    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

                    -- Jump to the type of the word under your cursor.
                    --  Useful when you're not sure what type a variable is and you want to see
                    --  the definition of its *type*, not where it was *defined*.
                    map('gD', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

                    -- Fuzzy find all the symbols in your current workspace.
                    --  Similar to document symbols, except searches over your entire project.
                    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

                    -- Rename the variable under your cursor.
                    --  Most Language Servers support renaming across files, etc.
                    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

                    -- Execute a code action, usually your cursor needs to be on top of an error
                    -- or a suggestion from your LSP for this to activate.
                    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

                    -- Opens a popup that displays documentation about the word under your cursor
                    --  See `:help K` for why this keymap.
                    map('K', vim.lsp.buf.hover, 'Hover Documentation')

                    -- WARN: This is not Goto Definition, this is Goto Declaration.
                    --  For example, in C this would take you to the header.
                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                    local client = vim.lsp.get_client_by_id(event.data.client_id)

                    if client and client.server_capabilities.documentHighlightProvider then
                        -- local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
                        -- vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                        --   buffer = event.buf,
                        --   group = highlight_augroup,
                        --   callback = vim.lsp.buf.document_highlight,
                        -- })
                        --
                        -- vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                        --   buffer = event.buf,
                        --   group = highlight_augroup,
                        --   callback = vim.lsp.buf.clear_references,
                        -- })
                        --
                        -- vim.api.nvim_create_autocmd('LspDetach', {
                        --   group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                        --   callback = function(event2)
                        --     vim.lsp.buf.clear_references()
                        --     vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                        --   end,
                        -- })
                    end

                    if client and client.server_capabilities.documentFormattingProvider then
                        map('<leader>fd', function()
                            vim.lsp.buf.format({ async = true })
                        end, '[F]ormat [D]ocument')
                    end

                    -- The following autocommand is used to enable inlay hints in your
                    -- code, if the language server you are using supports them
                    --
                    -- This may be unwanted, since they displace some of your code
                    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                        map('<leader>th', function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                        end, '[T]oggle Inlay [H]ints')
                    end
                end,
            })

            local mason = require('mason')

            mason.setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })

            local lspconfig = require("lspconfig")
            local mason_lspconfig = require("mason-lspconfig")
            local cmp_nvim_lsp = require("cmp_nvim_lsp")
            local capabilities = cmp_nvim_lsp.default_capabilities()
            local mason_tool_installer = require("mason-tool-installer")


            mason_lspconfig.setup({
                -- list of servers for mason to install
                ensure_installed = {
                    'luau_lsp',
                    'pyright',
                    'eslint',
                    'clangd',
                    'ruby_lsp',
                    'rubocop'
                },
            })

            mason_tool_installer.setup({
                ensure_installed = {
                    "prettier", -- prettier formatter
                    'stylua',
                    "isort",    -- python formatter
                    "black",    -- python formatter
                    "pylint",
                    "eslint_d",
                },
            })

            local sign_icons = {
                [vim.diagnostic.severity.ERROR] = " ",
                [vim.diagnostic.severity.WARN]  = " ",
                [vim.diagnostic.severity.INFO]  = " ",
                [vim.diagnostic.severity.HINT]  = "󰠠 ",
            }

            -- Apply diagnostic configuration for Neovim 0.11+
            vim.diagnostic.config({
                signs = {
                    enabled = true,  -- ensure signs are shown
                    text = sign_icons,
                    -- Optionally highlight the whole line or number differently
                    -- linehl = false,
                    -- numhl = false,
                },
                virtual_text = false,     -- customize other diagnostic display settings
                underline = true,
                severity_sort = true,
            })

            mason_lspconfig.setup({
                -- default handler for installed servers
                function(server_name)
                    lspconfig[server_name].setup({
                        capabilities = capabilities,
                    })
                end,
                ["lua_ls"] = function()
                    -- configure lua server (with special settings)
                    lspconfig["lua_ls"].setup({
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                completion = {
                                    callSnippet = 'Replace',
                                },
                                diagnostics = { disable = { 'missing-fields' } },
                            },
                        },
                    })
                end,
                ['clangd'] = function()
                    lspconfig['clangd'].setup({
                        capabilities = capabilities,
                        cmd = {"clangd"},
                        filetypes = {"c", "cpp", "objc", "objcpp"},
                    })
                end,
                -- ["ruby_lsp"] = function()
                --   lspconfig["ruby_lsp"].setup({
                --     init_options = {
                --       enabledFeatures = {
                --         semanticHighlighting = false
                --       }
                --     },
                --   })
                -- end
            })
        end,
    },

    { -- CMP
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
            "onsails/lspkind.nvim",
            {
                "L3MON4D3/LuaSnip",
                lazy = true,
                build = "make install_jsregexp",
            },
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            -- Load VSCode-style snippets on first insert
            vim.api.nvim_create_autocmd("InsertEnter", {
                once = true,
                callback = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                    luasnip.filetype_extend("ruby", { "rails" })
                end,
            })

            -- Setup nvim-cmp
            local sources = {
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer" },
                { name = "path" },
            }

            cmp.setup({
                completion = {
                    completeopt = "menu,menuone,preview,noselect",
                },
                experimental = {
                    ghost_text = false,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<M-CR>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<C-Space>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = sources,
                formatting = {
                    format = lspkind.cmp_format({
                        maxwidth = 50,
                        ellipsis_char = "...",
                    }),
                },
            })

            -- Add custom snippets
            luasnip.add_snippets("all", {
                luasnip.snippet("timestamp", {
                    luasnip.function_node(function()
                        return os.date("%Y%m%d%H%M")
                    end, {}),
                }),
            })
        end,
    },

    {
        "jiaoshijie/undotree",
        dependencies = "nvim-lua/plenary.nvim",
        config = true,
        keys = {
            { "<leader>.", "<cmd>lua require('undotree').toggle()<cr>" },
        },
    },

    {
        "folke/trouble.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        cmd = { "TroubleToggle", "Trouble" },
        opts = {
            position = "bottom",
            height = 10,
            width = 50,
            icons = true,
            mode = "document_diagnostics",
            severity = nil,
            fold_open = "",
            fold_closed = "",
            group = true,
            padding = true,
            auto_close = true,
            auto_preview = true,
            auto_fold = true,
            signs = {
                error = "",
                warning = "",
                hint = "",
                information = "",
                other = "",
            },
            use_diagnostic_signs = true,
            action_keys = {
                close = {"q", "<esc>"},
                cancel = "<c-e>",
                refresh = "r",
                jump = {"<cr>", "<tab>"},
                toggle_mode = "m",
                toggle_preview = "P",
                preview = "p",
                close_folds = {"zM", "zm"},
                open_folds = {"zR", "zr"},
                toggle_fold = {"zA", "za"},
                previous = "k",
                next = "j",
            },
        },
        keys = {
            { "<leader>xx", function() require("trouble").toggle("document_diagnostics") end, desc = "Document Diagnostics (Trouble)" },
            { "<leader>xX", function() require("trouble").toggle("workspace_diagnostics") end, desc = "Workspace Diagnostics (Trouble)" },
            { "<leader>xL", function() require("trouble").toggle("loclist") end, desc = "Location List (Trouble)" },
            { "<leader>xQ", function() require("trouble").toggle("quickfix") end, desc = "Quickfix List (Trouble)" },
        },
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },

        config = function()
            require('todo-comments').setup()

            vim.keymap.set("n", "]t", function()
                require("todo-comments").jump_next()
            end, { desc = "Next todo comment" })

            vim.keymap.set("n", "[t", function()
                require("todo-comments").jump_prev()
            end, { desc = "Previous todo comment" })

            -- You can also specify a list of valid jump keywords

            vim.keymap.set("n", "]t", function()
                require("todo-comments").jump_next({keywords = { "ERROR", "WARNING" }})
            end, { desc = "Next error/warning todo comment" })
        end,

        keys = {
            { "<leader>xT", "<cmd>TodoTelescope<cr>", desc = "Todo (Telescope)" },
            { "<leader>xL", "<cmd>TodoLocList<cr>", desc = "Todo Location List" },
            { "<leader>xQ", "<cmd>TodoQuickFix<cr>", desc = "Todo QuickFix" },
        }
    }
}

