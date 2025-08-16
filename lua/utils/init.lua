local LazyUtil = require("lazy.core.util")

---@class nulVim.utils: LazyUtilCore
---@class nulVim.utils
---@field config nulVim.config
---@field cmp nulVim.utils.cmp
---@field format nulVim.utils.format
---@field lsp nulVim.utils.lsp
---@field lualine nulVim.utils.lualine
---@field root nulVim.utils.root
local M = {}

setmetatable(M, {
  __index = function(t, k)
    if LazyUtil[k] then return LazyUtil[k] end
    t[k] = require("utils." .. k)
    return t[k]
  end,
})

---@param name string
function M.get_plugin(name) return require("lazy.core.config").spec.plugins[name] end

---@param name string
function M.has_plugin(name) return M.get_plugin(name) ~= nil end

---@param name string
---@return table
function M.get_plugin_opts(name)
  local plugin = M.get_plugin(name)
  if not plugin then return {} end
  return require("lazy.core.plugin").values(plugin, "opts", false)
end

-- vim.keymap.set wrapper and set `silent` to true by default.
---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts? vim.keymap.set.Opts
function M.map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

---@return boolean
function M.is_win()
  if vim.fn.has("g:os") == 0 then
    return vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 or vim.fn.has("win16") == 1
  end
  return false
end

return M
