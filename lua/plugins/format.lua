return {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = nulVim.config.keymaps.conform,
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        default_format_opts = {
            lsp_format = "fallback",
            quiet = false,
        },
        formatters = {
            stylua = {
                prepend_args = function()
                    local indent_type = vim.o.expandtab and "Spaces" or "Tabs"
                    local indent_width = tostring(vim.o.tabstop)

                    local table = {
                        "--indent-type",
                        indent_type,
                        "--indent-width",
                        indent_width,
                        "--collapse-simple-statement",
                        "Always",
                    }
                    return table
                end,
            },
        },
        formatters_by_ft = {
            c = { "clang-format" },
            cpp = { "clang-format" },
            lua = { "stylua" },
            zig = { "zigfmt" },
        },
        format_on_save = {
            timeout_ms = 500,
        },
    },
}
