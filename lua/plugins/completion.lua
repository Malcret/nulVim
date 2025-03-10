return {
  {
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts_extend = {
      "sources.completion.enable_providers",
      "sources.default",
    },
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
        kind_icons = nulVim.config.icons.kinds,
      },
      completion = {
        accept = {
          -- experimental auto-brackets support
          auto_brackets = { enabled = false },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = false,
        },
        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
      },
      cmdline = {
        enabled = true,
        keymap = {
          preset = "default",
        },
        completion = {
          menu = {
            auto_show = true,
          },
        },
      },
      keymap = {
        preset = "default",
      },
      -- experimental signature help support
      signature = {
        enabled = true,
      },
      snippets = {
        preset = "luasnip",
        expand = function(snippet) return nulVim.cmp.snippet_expand(snippet) end,
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          --   minuet = {
          --     name = "minuet",
          --     module = "minuet.blink",
          --     score_offset = 8,
          --   },
        },
      },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    lazy = true,
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load({
            paths = { vim.fn.stdpath("config") .. "/snippets" },
          })
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },
}
