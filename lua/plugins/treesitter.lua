return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  main = "nvim-treesitter.configs",
  opts = {
    ensure_installed = {
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
    },
    auto_install = true,
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
  },
}
