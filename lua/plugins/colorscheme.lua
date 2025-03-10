return {
  {
    "catppuccin/nvim",
    enabled = vim.g.colorscheme == "catppuccin",
    lazy = false,
    priority = 1000,
    name = "catppuccin",
    ---@module "catppuccin"
    ---@type CatppuccinOptions
    opts = {
      flavor = "mocha",
      default_integrations = false,
      integrations = {
        blink_cmp = true,
        dap = true,
        dap_ui = true,
        flash = true,
        fidget = true,
        gitsigns = true,
        lsp_trouble = true, -- with my custom colorscheme, it looks better when deactivated
        mason = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
            ok = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
        rainbow_delimiters = true,
        snacks = true,
        treesitter = true,
        which_key = true,
      },
      color_overrides = {
        mocha = {
          rosewater = "#efc9c2",
          flamingo = "#ebb2b2",
          pink = "#f2a7de",
          mauve = "#b889f4",
          red = "#ea7183",
          maroon = "#ea838c",
          peach = "#f39967",
          yellow = "#eaca89",
          green = "#96d382",
          teal = "#78cec1",
          sky = "#91d7e3",
          sapphire = "#68bae0",
          blue = "#739df2",
          lavender = "#a0a8f6",

          -- TODO: try default or contrast mocha colors with inverted base/crust

          text = "#b5c1f1",
          subtext1 = "#a6b0d8",
          subtext0 = "#959ec2",

          overlay2 = "#7d8296",
          overlay1 = "#676b80",
          overlay0 = "#464957",

          surface2 = "#3a3d4a",
          surface1 = "#2f313d",
          surface0 = "#1d1e29",

          base = "#0b0b12",
          mantle = "#11111a",
          -- crust = "#191926",
          crust = "#000000",
        },
      },
      highlight_overrides = {
        all = function(colors)
          return {
            CurSearch = { bg = colors.flamingo },
            IncSearch = { bg = colors.flamingo },

            -- Float windows
            NormalFloat = { bg = colors.mantle },
            Float = { bg = colors.mantle },
            FloatTitle = { fg = colors.crust, bg = colors.mauve, style = { "bold" } },
            FloatBorder = { fg = colors.peach, bg = colors.mantle },

            -- Snacks
            SnacksPickerInputTitle = { fg = colors.crust, bg = colors.red, style = { "bold" } },
            SnacksPickerInputBorder = { bg = colors.surface0 },
            SnacksPickerListTitle = { fg = colors.crust, bg = colors.sapphire, style = { "bold" } },
            SnacksPickerPreviewTitle = { fg = colors.crust, bg = colors.green, style = { "bold" } },
            -- TODO: SnacksPickerInput and config in snacks

            -- Trouble
            TroubleNormal = { bg = colors.mantle },
          }
        end,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
