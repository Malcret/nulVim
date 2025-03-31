return {
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "j-hui/fidget.nvim",
      "Fildo7525/pretty_hover",
    },
    ---@class PluginLspOpts
    opts = {
      ---@type vim.diagnostic.Opts
      diagnostics = {
        virtual_text = {
          spacing = 4,
          -- prefix = "●",
          prefix = "icons",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = nulVim.config.icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = nulVim.config.icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = nulVim.config.icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = nulVim.config.icons.diagnostics.Info,
          },
        },
      },
      inlay_hints = {
        enabled = vim.g.inlayhints,
        exclude = {},
      },
      codelens = {
        enabled = vim.g.codelens,
      },
      servers = {
        asm_lsp = {},
        bashls = {},
        clangd = {
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern(
              "Makefile",
              "configure.ac",
              "configure.in",
              "config.h.in",
              "meson.build",
              "meson_options.txt",
              "build.ninja"
            )(fname) or require("lspconfig.util").root_pattern(
              ".clangd",
              ".clang-tidy",
              ".clang-format",
              "compile_commands.json",
              "compile_flags.txt"
            )(fname) or vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
          end,
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            -- "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
        lua_ls = {},
        pylyzer = {},
        zls = {},
      },
      setup = {
        clangd = function(_, opts)
          local clangd_ext_opts = nulVim.get_plugin_opts("clangd_extensions.nvim")
          require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
          return false
        end,
      },
    },
    ---@param opts PluginLspOpts
    config = function(_, opts)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("nulVim_lsp_attach", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local buffer = event.buf

          -- vim.bo[buffer].formatexpr = nil

          -- Highlight references under the curosr
          if nulVim.lsp.has_method(buffer, client, "documentHighlight") then
            local highlight_group = vim.api.nvim_create_augroup("nulVim_document_highlight", { clear = false })

            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = buffer,
              group = highlight_group,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = buffer,
              group = highlight_group,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd({ "LspDetach" }, {
              group = vim.api.nvim_create_augroup("nulVim_lsp_detach_document_highlight", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({
                  group = highlight_group,
                  buffer = event2.buf,
                })
              end,
            })
          end

          -- Inlay hints
          if opts.inlay_hints.enabled and nulVim.lsp.has_method(buffer, client, "inlayHint") then
            if
              vim.api.nvim_buf_is_valid(buffer)
              and vim.bo[buffer].buftype == ""
              and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
            then
              vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
            end
          end

          -- Code lens
          if opts.codelens.enabled and nulVim.lsp.has_method(buffer, client, "codeLens") then
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
              buffer = buffer,
              callback = vim.lsp.codelens.refresh,
            })
          end

          -- Load keymaps
          nulVim.config.keymaps.lsp(buffer, client)
        end,
      })

      -- Set diagnostics icon
      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = function(diagnostic)
          local icons = nulVim.config.icons.diagnostics
          for d, icon in pairs(icons) do
            if diagnostic.severity == vim.diagnostic.severity[d:upper()] then return icon end
          end
          return "●"
        end
      end
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- Add 'blink.cmp' capabilities to lsp servers
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("blink.cmp").get_lsp_capabilities()
      )

      -- Setup lsp servers
      -- require("mason-lspconfig").setup({
      --   automatic_installation = true,
      --   ensure_installed = opts.servers,
      --   handlers = {
      --     function(server_name)
      --       local server = opts.servers[server_name] or {}
      --       server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
      --       require("lspconfig")[server_name].setup(server)
      --     end,
      --   },
      -- })

      local servers = opts.servers

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        if server_opts.enabled == false then return end

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then return end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then return end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- get all the servers that are available through mason-lspconfig
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
            if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
              setup(server)
            else
              ensure_installed[#ensure_installed + 1] = server
            end
          end
        end
      end

      if have_mason then
        ---@diagnostic disable-next-line: missing-fields
        mlsp.setup({
          ensure_installed = vim.tbl_deep_extend(
            "force",
            ensure_installed,
            nulVim.get_plugin_opts("mason-lspconfig.nvim").ensure_installed or {}
          ),
          handlers = { setup },
        })
      end
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = nulVim.config.keymaps.mason,
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    ---@module "mason"
    ---@type MasonSettings
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      ensure_installed = {
        -- Formaters
        "asmfmt",
        "clang-format",
        "prettierd",
        "shfmt",
        "stylua",
        "yamlfmt",
        -- DAP
        "codelldb",
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)

      local mr = require("mason-registry")

      -- Trigger `FileType` event on package installed
      mr:on("package:install:success", function()
        vim.defer_fn(
          function()
            require("lazy.core.handler.event").trigger({
              event = "FileType",
              buffer = vim.api.nvim_get_current_buf(),
            })
          end,
          100
        )
      end)

      -- Auto install `ensure_installed`
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then p:install() end
        end
      end)
    end,
  },
  -- UI for LSP progress messages
  {
    "j-hui/fidget.nvim",
    lazy = true,
    opts = {
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = nulVim.config.keymaps.trouble,
    ---@module "trouble"
    ---@type trouble.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      modes = {
        lsp = {
          win = { position = "right" },
        },
      },
    },
    specs = {
      "folke/snacks.nvim",
      opts = function(_, opts)
        return vim.tbl_deep_extend("force", opts or {}, {
          picker = {
            actions = require("trouble.sources.snacks").actions,
            win = {
              input = {
                keys = {
                  ["<c-t>"] = {
                    "trouble_open",
                    mode = { "n", "i" },
                  },
                },
              },
            },
          },
        })
      end,
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    ---@module "lazydev"
    ---@type lazydev.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "nulVim" } },
      },
    },
    config = function(_, opts)
      require("lazydev").setup(opts)

      local blk = require("blink.cmp")
      blk.add_source_provider("lazydev", {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      })
      blk.add_filetype_source("lua", "lazydev")
      -- NOTE: for now, you need to explicitly specify all sources, because default sources are not copyed
      blk.add_filetype_source("lua", "lsp")
      blk.add_filetype_source("lua", "path")
      blk.add_filetype_source("lua", "snippets")
      blk.add_filetype_source("lua", "buffer")
    end,
  },
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    opts = {
      inlay_hints = {
        inline = false,
      },
      ast = {
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
      },
    },
    config = function() end,
  },
  {
    "Fildo7525/pretty_hover",
    lazy = true,
    opts = {},
  },
}
