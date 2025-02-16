-- Set leader key.
-- See ':help mapleader' and ':help maplocalleader' for more informations.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Import config files.
-- require("config.options")
-- require("config.autocmds")
-- require("config.keymaps").nvim()
-- require("config.lazy")
require("config")
