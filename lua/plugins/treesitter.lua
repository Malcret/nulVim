return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  -- main = "nvim-treesitter.configs",
  ---@module "nvim-treesitter"
  ---@type TSConfig
  -- opts = {
  --   ensure_installed = {
  --     "bash",
  --     "c",
  --     "json",
  --     "jsonc",
  --     "lua",
  --     "luadoc",
  --     "luap",
  --     "markdown",
  --     "regex",
  --     "toml",
  --     "vim",
  --     "vimdoc",
  --     "xml",
  --     "yaml",
  --     "zig",
  --   },
  --   auto_install = true,
  --   highlight = {
  --     enable = true,
  --   },
  --   indent = {
  --     enable = true,
  --   },
  -- },
  opts = {},
  config = function(_, opts)
    local ts = require("nvim-treesitter")
    ts.setup(opts)
    ts.install({
      "bash",
      "c",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "regex",
      "toml",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
      "zig",
    })
  end,
}
