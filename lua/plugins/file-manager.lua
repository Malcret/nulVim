return {
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      float = {
        max_width = 0.7,
        max_height = 0.8,
        border = "solid",
      },
    },
    keys = nulVim.config.keymaps.oil,
  },
}
