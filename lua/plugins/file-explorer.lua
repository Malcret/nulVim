return {
  {
    "stevearc/oil.nvim",
    -- NOTE: Need to load during startup or Neovim will use netwr to open directory passed as parameter.
    lazy = false,
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
