return {
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    dependencies = {
        "rafamadriz/friendly-snippets",
        {
            "saghen/blink.compat",
            version = "*",
            optional = true,
            opts = {},
        },
    },
    opts_extend = {
        "sources.completion.enable_providers",
        -- "sources.compat",
        "sources.default",
    },
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
        completion = {
            menu = {
                draw = {
                    treesitter = {
                        "lsp",
                    },
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 300,
            },
            ghost_text = {
                enabled = true,
            },
            list = {
                selection = {
                    preselect = true,
                    auto_insert = false,
                },
            },
        },
        -- experimental signature help support
        signature = {
            enabled = true,
        },
    },
}
