return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@module "snacks"
  ---@type snacks.Config
  opts = {
    bufdelete = { enabled = true },
    ---@type snacks.indent.Config
    indent = {
      enabled = true,
      animate = { enabled = false },
      scope = { underline = true },
    },
    input = { enabled = true },
    lazygit = { enabled = true },
    scope = {
      enabled = true,
      treesitter = {
        blocks = { enabled = true },
      },
    },
    statuscolumn = { enabled = true },
    terminal = { enabled = true },
    picker = {
      enabled = true,
      layout = {
        preset = "custom",
      },
      layouts = {
        custom = {
          layout = {
            backdrop = false,
            border = "none",
            box = "horizontal",
            width = 0.7,
            min_width = 120,
            height = 0.8,
            {
              box = "vertical",
              border = "none",
              {
                win = "input",
                height = 1,
                border = "solid",
                title = "{title} {live} {flags}",
                title_pos = "center",
              },
              { win = "list", border = "solid", title = "Results", title_pos = "center" },
            },
            { win = "preview", width = 0.5, border = "solid", title = "{preview}", title_pos = "center" },
          },
        },
        ivy = {
          layout = {
            box = "vertical",
            backdrop = false,
            row = -1,
            width = 0,
            height = 0.4,
            border = "none",
            {
              title = " {title} {live} {flags}",
              title_pos = "left",
              win = "input",
              height = 1,
              border = "solid",
            },
            {
              box = "horizontal",
              { win = "list", border = "none" },
              { win = "preview", title = "{preview}", width = 0.6, border = "left" },
            },
          },
        },
        select = {
          ---@diagnostic disable-next-line: assign-type-mismatch
          preview = false,
          layout = {
            backdrop = false,
            width = 0.5,
            min_width = 80,
            height = 0.4,
            min_height = 3,
            border = "none",
            box = "vertical",
            {
              win = "input",
              height = 1,
              border = "solid",
              title = "{title}",
              title_pos = "center",
            },
            { win = "list", border = "none" },
          },
        },
        vscode = {
          ---@diagnostic disable-next-line: assign-type-mismatch
          preview = false,
          layout = {
            backdrop = false,
            row = 1,
            width = 0.4,
            min_width = 80,
            height = 0.4,
            border = "none",
            box = "vertical",
            {
              win = "input",
              height = 1,
              border = "solid",
              title = "{title} {live} {flags}",
              title_pos = "center",
            },
            { win = "list", border = "hpad" },
          },
        },
      },
    },
    util = { enabled = true },
  },
  config = function(_, opts)
    _G.Snacks = require("snacks")
    Snacks.setup(opts)

    if opts.lazygit.enabled then nulVim.config.keymaps.snacks_lazygit() end
    if opts.terminal.enabled then nulVim.config.keymaps.snacks_terminal() end
  end,
}
