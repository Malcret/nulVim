return {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    opts = {
        on_attach = function(buffer) MltVim.config.keymaps.gitsigns(buffer) end,
    },
}
