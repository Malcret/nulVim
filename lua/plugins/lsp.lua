return {
    {
        "neovim/nvim-lspconfig",
        event = "LazyFile",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "j-hui/fidget.nvim",
        },
        ---@class PluginLspOpts
        opts = {
            ---@type vim.diagnostic.Opts
            diagnostics = {
                virtual_text = {
                    spacing = 4,
                    -- prefix = "●",
                    prefix = "icons",
                },
                severity_sort = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = MltVim.config.icons.diagnostics.Error,
                        [vim.diagnostic.severity.WARN] = MltVim.config.icons.diagnostics.Warn,
                        [vim.diagnostic.severity.HINT] = MltVim.config.icons.diagnostics.Hint,
                        [vim.diagnostic.severity.INFO] = MltVim.config.icons.diagnostics.Info,
                    },
                },
            },
            inlay_hints = {
                enabled = true,
                exclude = {},
            },
            codelens = {
                enabled = false,
            },
            servers = {
                bashls = {},
                clangd = {},
                lua_ls = {},
                pylyzer = {},
                zls = {},
            },
        },
        ---@param opts PluginLspOpts
        config = function(_, opts)
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("mltvim_lsp_attach", { clear = true }),
                callback = function(event)
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    local buffer = event.buf

                    -- Highlight references under the curosr
                    if
                        client
                        and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, buffer)
                    then
                        local highlight_group =
                            vim.api.nvim_create_augroup("mltvim_document_highlight", { clear = false })

                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = buffer,
                            group = highlight_group,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = buffer,
                            group = highlight_group,
                            callback = vim.lsp.buf.clear_references,
                        })

                        vim.api.nvim_create_autocmd({ "LspDetach" }, {
                            group = vim.api.nvim_create_augroup(
                                "mltvim_lsp_detach_document_highlight",
                                { clear = true }
                            ),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds({
                                    group = highlight_group,
                                    buffer = event2.buf,
                                })
                            end,
                        })
                    end

                    -- Inlay hints
                    if
                        opts.inlay_hints.enabled
                        and client
                        and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, buffer)
                    then
                        if
                            vim.api.nvim_buf_is_valid(buffer)
                            and vim.bo[buffer].buftype == ""
                            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
                        then
                            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
                        end
                    end

                    -- Code lens
                    if
                        opts.codelens.enabled
                        and client
                        and client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens)
                    then
                        vim.lsp.codelens.refresh()
                        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                            buffer = buffer,
                            callback = vim.lsp.codelens.refresh,
                        })
                    end

                    -- Load keymaps
                    MltVim.config.keymaps.lsp(buffer, client)
                end,
            })

            -- Set diagnostics icon
            if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
                opts.diagnostics.virtual_text.prefix = function(diagnostic)
                    local icons = MltVim.config.icons.diagnostics
                    for d, icon in pairs(icons) do
                        if diagnostic.severity == vim.diagnostic.severity[d:upper()] then return icon end
                    end
                    return "●"
                end
            end
            vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

            -- Add 'blink.cmp' capabilities to lsp servers
            local capabilities = vim.tbl_deep_extend(
                "force",
                vim.lsp.protocol.make_client_capabilities(),
                require("blink.cmp").get_lsp_capabilities()
            )

            -- Setup lsp servers
            require("mason-lspconfig").setup({
                automatic_installation = true,
                ensure_installed = opts.servers,
                handlers = {
                    function(server_name)
                        local server = opts.servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })
        end,
    },
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts_extend = { "ensure_installed" },
        opts = {
            ensure_installed = {
                "clang-format",
                "stylua",
            },
        },
    },
    -- UI for LSP progress messages
    {
        "j-hui/fidget.nvim",
        lazy = true,
        opts = {
            notification = {
                window = {
                    winblend = 0,
                },
            },
        },
    },
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        keys = MltVim.config.keymaps.trouble,
        ---@module "trouble"
        ---@type trouble.Config
        opts = {
            modes = {
                lsp = {
                    win = { position = "right" },
                },
            },
        },
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        ---@module "lazydev"
        ---@type lazydev.Config
        ---@diagnostic disable-next-line: missing-fields
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
        config = function(_, opts)
            require("lazydev").setup(opts)

            local blk = require("blink.cmp")
            blk.add_provider("lazydev", {
                name = "LazyDev",
                module = "blink.cmp.sources.lsp",
            })
        end,
    },
}
