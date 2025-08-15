return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false,
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
    ft = "markdown",
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      completions = { blink = { enabled = true } },
      file_types = { "markdown", "vimwiki" },
    },
    config = function(_, opts)
      vim.treesitter.language.register("markdown", "vimwiki")
      require("render-markdown").setup(opts)
    end,
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    priority = 49,
    dependencies = { "saghen/blink.cmp" },
    opts = {},
  },
}
