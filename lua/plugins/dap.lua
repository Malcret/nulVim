return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            -- UI
            "rcarriga/nvim-dap-ui",
            {
                -- Virtual text
                "theHamsta/nvim-dap-virtual-text",
                opts = {},
            },
        },
        keys = MltVim.config.keymaps.dap,
        config = function()
            -- Set DAP icons
            for name, sign in pairs(MltVim.config.icons.dap) do
                sign = type(sign) == "table" and sign or { sign }
                vim.fn.sign_define(
                    "Dap" .. name,
                    { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
                )
            end

            -- Setup DAP with VSCode launch.json
            ---@diagnostic disable-next-line: duplicate-set-field
            require("dap.ext.vscode").json_decode = function(str)
                return vim.json.decode(require("plenary.json").json_strip_comments(str))
            end
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "nvim-neotest/nvim-nio",
        },
        keys = MltVim.config.keymaps.dap_ui,
        opts = {},
        config = function(_, opts)
            local dap = require("dap")
            local dapui = require("dapui")

            dapui.setup(opts)

            dap.listeners.before.attach.dapui_config = function() dapui.open() end
            dap.listeners.before.launch.dapui_config = function() dapui.open() end
            dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
            dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
        end,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        cmd = { "DapInstall", "DapUninstall" },
        ---@module "mason-nvim-dap"
        ---@type MasonNvimDapSettings
        opts = {
            automatic_installation = false,
            ensure_installed = {},
            handlers = {},
        },
    },
}
