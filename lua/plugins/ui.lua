return {
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    ---@module "lualine"
    opts = {
      options = {
        theme = vim.g.colorscheme,
        globalstatus = vim.o.laststatus,
        disable_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          {
            "diff",
            symbols = {
              added = nulVim.config.icons.git.added,
              modified = nulVim.config.icons.git.modified,
              removed = nulVim.config.icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_c = {
          nulVim.lualine.root_dir(),
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { nulVim.lualine.pretty_path(), padding = { left = 0, right = 1 } },
          {
            "diagnostics",
            symbols = {
              error = nulVim.config.icons.diagnostics.Error,
              warn = nulVim.config.icons.diagnostics.Warn,
              info = nulVim.config.icons.diagnostics.Info,
              hint = nulVim.config.icons.diagnostics.Hint,
            },
          },
        },
        lualine_x = {
          {
            function() return "  " .. require("dap").status() end,
            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = function() return { fg = Snacks.util.color("Debug") } end,
          },
        },
        lualine_y = {
          "encoding",
          "fileformat",
        },
        lualine_z = {
          { "progress", separator = "", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 0 } },
        },
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    ---@module "bufferline"
    ---@type bufferline.UserConfig
    opts = {
      options = {
        always_show_bufferline = false,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          local icons = nulVim.config.icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        close_command = function(n) Snacks.bufdelete(n) end,
        right_mouse_command = function(n) Snacks.bufdelete(n) end,
        separator_style = "thin",
      },
      highlights = function()
        local color = require("catppuccin.palettes").get_palette()

        local hl = require("catppuccin.groups.integrations.bufferline").get({
          custom = {
            all = {
              -- Buffers
              buffer_visible = { fg = color.text },
              buffer_selected = { fg = color.lavender },
              -- Empty
              fill = { bg = color.base },
            },
          },
        })

        return hl()
      end,
    },
  },
}
