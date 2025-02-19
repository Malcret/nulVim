return {
    {
        "folke/ts-comments.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
        "folke/todo-comments.nvim",
        event = "LazyFile",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
        config = function(_, opts)
            require("todo-comments").setup(opts)

            nulVim.config.keymaps.todo_comments()
        end,
    },
}
