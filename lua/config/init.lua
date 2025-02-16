_G.MltVim = require("utils")

MltVim.config = {}
MltVim.config.keymaps = require("config.keymaps")
MltVim.config.icons = require("config.icons")

MltVim.config.keymaps.nvim()
require("config.options")
require("config.autocmds")
require("config.lazy")
