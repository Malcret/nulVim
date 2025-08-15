return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    ---@module "persistence"
    ---@type Persistence.Config
    opts = {
      dir = vim.fn.stdpath("state") .. "/sessions/",
      need = 3,
    },
    keys = nulVim.config.keymaps.persistence,
  },
}
