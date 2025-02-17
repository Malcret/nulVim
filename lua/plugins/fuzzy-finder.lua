return {
    {
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        branch = "0.1.x",
        dependencies = {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                lazy = true,
                build = "make",
                cond = function() return vim.fn.executable("make") == 1 end,
            },
        },
        opts = {
            extensions = {
                fzf = {},
            },
        },
        config = function(_, opts)
            require("telescope").setup(opts)

            -- Load 'telescope-fzf-native'
            require("telescope").load_extension("fzf")

            -- Import keymaps
            require("config.keymaps").telescope()
        end,
    },
    {
        "folke/snacks.nvim",
        opts = {
            picker = { enabled = true },
        },
        keys = MltVim.config.keymaps.snacks_picker,
    },
}
