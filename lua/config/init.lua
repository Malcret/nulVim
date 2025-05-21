---@class nulVim.config
---@field icons nulVim.config.icons
---@field keymaps nulVim.config.keymaps
local M = {}

---@type string[]
local _skip_table = {
  "autocmds",
  "events",
  "options",
}

---@param value string
---@return boolean
local function _skip(value)
  for _, val in ipairs(_skip_table) do
    if val == value then return true end
  end
  return false
end

setmetatable(M, {
  __index = function(t, k)
    if not _skip(k) then
      t[k] = require("config." .. k)
      return t[k]
    end
  end,
})

function M.setup()
  -- NOTE: Workarround for <Tab>/<S-Tab> insert mode mappings conflict with vim.snippet.expand()
  -- if vim.fn.has("nvim-0.11") == 1 then
  --   -- Ensure that forced and not configurable `<Tab>` and `<S-Tab>`
  --   -- buffer-local mappings don't override already present ones
  --   local expand_orig = vim.snippet.expand
  --   vim.snippet.expand = function(...)
  --     local tab_map = vim.fn.maparg("<Tab>", "i", false, true)
  --     local stab_map = vim.fn.maparg("<S-Tab>", "i", false, true)
  --     expand_orig(...)
  --     vim.schedule(function()
  --       tab_map.buffer, stab_map.buffer = 1, 1
  --       -- Override temporarily forced buffer-local mappings
  --       vim.fn.mapset("i", false, tab_map)
  --       vim.fn.mapset("i", false, stab_map)
  --     end)
  --   end
  -- end

  -- Bootstrap lazy.nvim
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local out = vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "--branch=stable",
      "https://github.com/folke/lazy.nvim.git",
      lazypath,
    })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end
  vim.opt.rtp:prepend(lazypath)

  _G.nulVim = require("utils")
  nulVim.config = M

  nulVim.config.keymaps.nvim()
  require("config.options")
  vim.filetype.add({ extension = { h = "c" } })
  vim.filetype.add({ extension = { bin = "xxd" } })
  require("config.autocmds")

  -- LazyFile event
  local event = require("lazy.core.handler.event")
  event.mappings.LazyFile = { id = "LazyFile", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }
  event.mappings["User LazyFile"] = event.mappings.LazyFile

  -- Setup lazy.nvim
  require("lazy").setup(
    ---@module "lazy"
    ---@type LazyConfig
    {
      spec = { { import = "plugins" } },
      install = { colorscheme = { "catppuccin" } },
      checker = { enable = true },
      change_detection = { enabled = false },
    }
  )
end

return M
