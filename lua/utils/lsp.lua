---@class nulVim.utils.lsp
local M = {}

---@param buffer integer
---@param client vim.lsp.Client?
---@param protocol string
---@return boolean
function M.has_method(buffer, client, protocol)
  if client and client:supports_method(vim.lsp.protocol.Methods["textDocument_" .. protocol], buffer) then
    return true
  end
  return false
end

return M
