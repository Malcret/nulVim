---@class nulVim.utils.format
local M = {}

---@return integer
function M.formatexpr()
  if nulVim.has_plugin("conform.nvim") then
    print("formatexpr")
    return require("conform").formatexpr()
  end
  print("nop")
  return vim.lsp.formatexpr({ timeout_ms = 3000 })
end

---@param lnum integer?
---@return integer?
function M.indentexpr(lnum)
  print("indentexpr")
  if nulVim.has_plugin("nvim-treesitter") then
    local i = require("nvim-treesitter.indent").get_indent(lnum or vim.v.lnum)
    print(i)
    return i
  end
  print("nil")
  return nil
end

return M
