local M = {}

---@param name string
M.get_plugin = function(name) return require("lazy.core.config").spec.plugins[name] end

---@param name string
M.has_plugin = function(name) return M.get_plugin(name) ~= nil end

---@param name string
---@return table
M.get_plugin_opts = function(name)
    local plugin = M.get_plugin(name)
    if not plugin then return {} end
    return require("lazy.core.plugin").values(plugin, "opts", false)
end

return M
