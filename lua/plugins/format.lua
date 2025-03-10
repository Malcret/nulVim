return {
  "stevearc/conform.nvim",
  lazy = true,
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = nulVim.config.keymaps.conform,
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    default_format_opts = {
      lsp_format = "fallback",
      quiet = false,
    },
    formatters_by_ft = {
      asm = { "asmfmt" },
      c = { "clang-format" },
      cpp = { "clang-format" },
      css = { "prettierd" },
      html = { "prettierd" },
      json = { "prettierd" },
      jsonc = { "prettierd" },
      lua = { "stylua" },
      sh = { "shfmt" },
      yaml = { "yamlfmt" },
      zig = { "zigfmt" },
    },
    formatters = {
      ["clang-format"] = {
        prepend_args = {
          "--style=file",
        },
      },
      stylua = {
        prepend_args = function()
          local indent_type = vim.filetype.get_option("lua", "expandtab") and "Spaces" or "Tabs"
          local indent_width = vim.filetype.get_option("lua", "shiftwidth")

          local table = {
            "--indent-type",
            indent_type,
            "--indent-width",
            indent_width,
            "--collapse-simple-statement",
            "Always",
          }
          return table
        end,
      },
    },
    format_on_save = {
      timeout_ms = 500,
    },
  },
}
