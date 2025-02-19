_G.nulVim = require("utils")

nulVim.config = {}
nulVim.config.keymaps = require("config.keymaps")
nulVim.config.icons = require("config.icons")

nulVim.config.keymaps.nvim()
require("config.options")
require("config.autocmds")
require("config.lazy")
