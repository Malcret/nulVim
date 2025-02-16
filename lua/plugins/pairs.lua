return {
    {
        "echasnovski/mini.pairs",
        version = false,
        event = "VeryLazy",
        opts = {
            modes = {
                insert = true,
                command = true,
                terminal = false,
            },
            skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
            skip_ts = {
                "string",
            },
            skip_unbalanced = true,
            markdown = true,
        },
    },
    {
        "echasnovski/mini.surround",
        version = false,
        keys = function(_, keys)
            local opts = MltVim.get_plugin_opts("mini.surround")

            local mappings = {
                { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
                { opts.mappings.delete, desc = "Delete surrounding" },
                { opts.mappings.find, desc = "Find right surrounding" },
                { opts.mappings.find_left, desc = "Find left surrounding" },
                { opts.mappings.highlight, desc = "Highlight surrounding" },
                { opts.mappings.replace, desc = "Replace surrounding" },
                { opts.mappings.update_n_lines, desc = "Update MiniSurround.config.n_lines" },
            }
            mappings = vim.tbl_filter(function(m) return m[1] and #m[1] > 0 end, mappings)

            return vim.list_extend(mappings, keys)
        end,
        opts = {
            mappings = MltVim.config.keymaps.mini_surround,
        },
    },
}
