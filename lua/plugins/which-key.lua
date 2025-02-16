return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    ---@module "which-key"
    ---@type wk.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
        delay = 0,
        spec = require("config.keymaps").wich_key,
        triggers = {
            { "<auto>", mode = "nxsotc" },
            { "s", mode = { "n", "v" } },
        },
    },
}
