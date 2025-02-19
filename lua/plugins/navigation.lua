return {
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@module "flash"
        ---@type Flash.Config
        ---@diagnostic disable-next-line: missing-fields
        opts = {},
        keys = nulVim.config.keymaps.flash,
    },
}
