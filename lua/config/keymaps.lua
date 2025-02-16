local set = vim.keymap.set

local M = {}

-- WICH-KEY GROUPS

-- stylua: ignore
M.wich_key = {
    -- Groups
    { "gs", group = "Surround", mode = { "n", "v" } },
    { "<leader>c", group = "Code", mode = { "n", "v" } },
    { "<leader>d", group = "DAP/Document" },
    { "<leader>r", group = "Rename" },
    { "<leader>s", group = "Search" },
    { "<leader>w", group = "Workspace" },
    { "<leader>x", group = "Trouble" },

    -- Help
    { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "[Wich-Key] Buffer keymaps" },
}

-- NVIM

M.nvim = function()
    -- NAVIGATION

    -- Disable arrow keys in normal mode.
    set("n", "<left>", "<cmd>echo 'Use h to move!!'<CR>")
    set("n", "<right>", "<cmd>echo 'Use l to move!!'<CR>")
    set("n", "<up>", "<cmd>echo 'Use k to move!!'<CR>")
    set("n", "<down>", "<cmd>echo 'Use j to move!!'<CR>")

    -- Better keybinds for window navigation.
    set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
    set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
    set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
    set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

    -- TERMINAL

    -- Better keybind to quit terminal mode.
    -- See ':help terminal'.
    set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit termional mode" })

    -- UTILS

    -- Clear highlights on search when pressing <Esc> in normal mode.
    -- See ':help hlsearch'.
    set("n", "<Esc>", "<cmd>nohlsearch<CR>")

    -- Disable "s" key default behavior.
    set({ "n", "x" }, "s", "<Nop>")
    -- Disable <space> key default behavior.
    set("n", "<space>", "<Nop>")
end

-- CONFORM

-- stylua: ignore
M.conform = {
    -- FORMATTING

    -- Format the current buffer using conform.
    { "<leader>ff", function() require("conform").format({ async = true }) end, mode = { "n", "v" }, desc = "[Conform] Format" },
}

-- DAP

-- stylua: ignore
M.dap = {
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "[DAP] Breakpoint Condition" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "[DAP] Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "[DAP] Run/Continue" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "[DAP] Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "[DAP] Go to Line (No Execute)" },
    { "<leader>di", function() require("dap").step_into() end, desc = "[DAP] Step Into" },
    { "<leader>dj", function() require("dap").down() end, desc = "[DAP] Down" },
    { "<leader>dk", function() require("dap").up() end, desc = "[DAP] Up" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "[DAP] Run Last" },
    { "<leader>do", function() require("dap").step_out() end, desc = "[DAP] Step Out" },
    { "<leader>dO", function() require("dap").step_over() end, desc = "[DAP] Step Over" },
    { "<leader>dP", function() require("dap").pause() end, desc = "[DAP] Pause" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "[DAP] Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end, desc = "[DAP] Session" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "[DAP] Terminate" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "[DAP] Widgets" },
}

M.dap_ui = {
    { "<leader>du", function() require("dapui").toggle() end, desc = "[DAP] Toggle UI" },
    { "<leader>de", function() require("dapui").eval() end, desc = "[DAP] Eval", mode = { "n", "v" } },
}

-- FLASH

-- stylua: ignore
M.flash = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "[Flash] Jump" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "[Flash] Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "[Flash] Remote" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "[Flash] Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "[Flash] Toggle Search" },
}

-- GITSIGNS

---@param buffer integer
-- stylua: ignore
M.gitsigns = function(buffer)
    local gs = require("gitsigns")

    -- NAVIGATION

    set("n", "]c", function()
        if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
        else
            gs.nav_hunk("next")
        end
    end, { buffer = buffer, desc = "[Git] Jump to next git change" })
    set("n", "[c", function()
        if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
        else
            gs.nav_hunk("prev")
        end
    end, { buffer = buffer, desc = "[Git] Jump to previous git change" })

    -- ACTIONS

    set("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "[Git] Stage hunk" })
    set("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "[Git] Reset hunk" })

    set("n", "<leader>hs", function() gs.stage_hunk() end, { desc = "[Git] Stage hunk" })
    set("n", "<leader>hr", function() gs.reset_hunk() end, { desc = "[Git] Reset hunk" })
    set("n", "<leader>hS", function() gs.stage_buffer() end, { desc = "[Git] Stage buffer" })
    set("n", "<leader>hR", function() gs.reset_buffer() end, { desc = "[Git] Reset buffer" })
    set("n", "<leader>hp", function() gs.preview_hunk() end, { desc = "[Git] Preview hunk" })
    set("n", "<leader>hi", function() gs.preview_hunk_inline() end, { desc = "[Git] Preview hunk inline" })
    set("n", "<leader>hb", function() gs.blame_line() end, { desc = "[Git] Blame line" })
    set("n", "<leader>hd", function() gs.diffthis() end, { desc = "[Git] Diff against index" })
    set("n", "<leader>hD", function() gs.diffthis("@") end, { desc = "[Git] Diff against last commit" })

    -- TOGGLE

    set("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "[Git] Toggle current line blame" })
    set("n", "<leader>tw", gs.toggle_word_diff, { desc = "[Git] Toggle current word diff" })
end

-- LSP

---@param buffer integer
---@param client? vim.lsp.Client
-- stylua: ignore
M.lsp = function(buffer, client)
    local tsbi = require("telescope.builtin")

    -- GOTO

    -- Goto the definition of the word under the cursor.
    set("n", "gd", tsbi.lsp_definitions, { buffer = buffer, desc = "[LSP] Goto Definition" })
    -- Goto the declaration of the word under the cursor.
    set("n", "gD", vim.lsp.buf.declaration, { buffer = buffer, desc = "[LSP] Goto Declaration" })
    -- Goto the implementation of the word under the cursor.
    set("n", "gI", tsbi.lsp_implementations, { buffer = buffer, desc = "[LSP] Goto Implementation" })
    -- Goto the definition of the type of the word under the cursor.
    set("n", "<leader>D", tsbi.lsp_type_definitions, { buffer = buffer, desc = "[LSP] Goto type definition" })

    -- SEARCH

    -- Search LSP symbols in the current buffer.
    set("n", "<leader>ds", tsbi.lsp_document_symbols, { buffer = buffer, desc = "[LSP] Find document symbols" })
    -- Search LSP symbols in the entire workspace.
    set("n", "<leader>ws", tsbi.lsp_dynamic_workspace_symbols, { buffer = buffer, desc = "[LSP] Find workspace symbols" })

    -- CODE EDIT

    -- Renames all references to the symbol under the cursor.
    set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = buffer, desc = "[LSP] Rename symbol" })
    set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = buffer, desc = "[LSP] Code action" })

    -- INFORMATIONS

    -- Show hover informations about the word under the cursor.
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_hover, buffer) then
        set("n", "K", vim.lsp.buf.hover, { buffer = buffer, desc = "[LSP] Hover informations" })
    end

    -- Show signature informations about the word under the cursor.
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_signatureHelp, buffer) then
        set("n", "<leader>K", vim.lsp.buf.signature_help, { buffer = buffer, desc = "[LSP] Signature informations" })
    end
end

-- MINI.SURROUND

M.mini_surround = {
    add = "gsa",
    delete = "gsd",
    find = "gsf",
    find_left = "gsF",
    highlight = "gsh",
    replace = "gsr",
    update_n_lines = "gsn",
}

-- SNACKS

M.snacks_terminal = function()
    local snacks = require("snacks")

    set("n", "<leader>ft", function() snacks.terminal() end, { desc = "Toggle terminal" })
end

-- TELESCOPE

-- stylua: ignore
M.telescope = function()
    local tsbi = require("telescope.builtin")

    -- DOCUMENTATION

    -- Fuzzy search for help documentation.
    set("n", "<leader>sh", tsbi.help_tags, { desc = "[Telescope] Search help documentation" })
    -- Fuzzy search for man pages.
    set("n", "<leader>sm", tsbi.man_pages, { desc = "[Telescope] Search man pages" })

    -- FILES

    -- Fuzzy search for files in the current working directory.
    set("n", "<leader>sf", tsbi.find_files, { desc = "[Telescope] Search files" })
    -- Fuzzy search for files in the Neovim config directory.
    set("n", "<leader>sc", function() tsbi.find_files({ cwd = vim.fn.stdpath("config") }) end, { desc = "[Telescope] Search Neovim config files" })
end

-- TODO-COMMENTS

-- stylua: ignore
M.todo_comments = function()
    local tc = require("todo-comments")

    -- GOTO

    -- Jump to the next todo comment in the current buffer.
    set("n", "]t", tc.jump_next, { desc = "[Todo] Jump to next todo comment" })
    -- Jump to the previous todo comment in the current buffer.
    set("n", "[t", tc.jump_prev, { desc = "[Todo] Jump to previous todo comment" })

    -- FUZZY SEARCH

    -- Fuzzy search for todo comments in the entire workspace.
    set("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "[Todo] Search todo comments" })
    -- Fuzzy search for todo/fix/fixme comments in the entire workspace.
    set("n", "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", { desc = "[Todo] Search todo/fix/fixme comments" })

    -- TROUBLE

    -- Show todo comments in the Trouble window.
    set("n", "<leader>xt", "<cmd>Trouble todo toggle<cr>", { desc = "[Trouble] Todo comments" })
    -- Show todo/fix/fixme comments in the Trouble window.
    set("n", "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", { desc = "[Trouble] Todo/Fix/Fixme comments" })
end

-- TROUBLE

M.trouble = {
    -- Toggle diagnostics for the entire workspace.
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "[Trouble] Workspace diagnostics" },
    -- Toggle diagnostics for the current buffer.
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "[Trouble] Buffer diagnostics" },
    -- Toggle document symbols.
    { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "[Trouble] Symbols" },
    -- Toggle LSP definitions, references, implementations, type definitions, and declarations.
    { "<leader>cS", "<cmd>Trouble lsp toggle<cr>", desc = "[Trouble] LSP" },
    -- Toggle location list.
    { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "[Trouble] Location list" },
    -- Toggle quickfix list.
    { "<leader>xL", "<cmd>Trouble qflist toggle<cr>", desc = "[Trouble] Quickfix list" },
}

return M
