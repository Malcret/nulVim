return {
    "catppuccin/nvim",
    lazy = false,
    priority = 10000,
    name = "catppuccin",
    opts = {
        flavor = "mocha",
        default_integrations = false,
        integrations = {
            blink_cmp = true,
            dap = true,
            dap_ui = true,
            -- diffview = true,
            flash = true,
            fidget = true,
            -- fzf = true,
            gitsigns = true,
            indent_blankline = {
                enabled = true,
                scope_color = "lavender",
                colored_indent_levels = false,
            },
            lsp_trouble = true,
            mason = true,
            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = { "italic" },
                    hints = { "italic" },
                    warnings = { "italic" },
                    information = { "italic" },
                    ok = { "italic" },
                },
                underlines = {
                    errors = { "underline" },
                    hints = { "underline" },
                    warnings = { "underline" },
                    information = { "underline" },
                    ok = { "underline" },
                },
                inlay_hints = {
                    background = true,
                },
            },
            -- neogit = true,
            -- rainbow_delimiters = true,
            snacks = true,
            treesitter = true,
            which_key = true,
        },
    },
    config = function(_, opts)
        require("catppuccin").setup(opts)
        vim.cmd.colorscheme("catppuccin")
    end,
}
