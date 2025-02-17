return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@module "snacks"
    ---@type snacks.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
        indent = {
            enabled = true,
            animate = { enabled = false },
        },
        input = { enabled = true },
        lazygit = { enabled = true },
        scope = { enabled = true },
        terminal = { enabled = true },
    },
    config = function(_, opts)
        require("snacks").setup(opts)

        if opts.lazygit.enabled then MltVim.config.keymaps.snacks_lazygit() end
        if opts.terminal.enabled then MltVim.config.keymaps.snacks_terminal() end
    end,
}
