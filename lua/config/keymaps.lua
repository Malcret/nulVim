local set = vim.keymap.set

local M = {}

-- WICH-KEY GROUPS

-- stylua: ignore
M.wich_key = {
    mode = { "n", "v" },

    -- Groups
    { "<leader>c", group = "Code" },
    { "<leader>d", group = "Debug" },
    { "<leader>f", group = "File/Find" },
    { "<leader>g", group = "Git" },
    { "<leader>gh", group = "Hunk" },
    { "<leader>r", group = "Rename" },
    { "<leader>s", group = "Search" },
    { "<leader>x", group = "Diagnostics/Quickfix" },
    { "[", group = "Prev" },
    { "]", group = "Next" },
    { "g", group = "Goto" },
    { "gs", group = "Surround" },
    {
        "<leader>b",
        group = "Buffer",
        expand = function() return require("which-key.extras").expand.buf() end,
    },
    {
        "<leader>w",
        group = "Window",
        proxy = "<c-w>",
        expand = function() return require("which-key.extras").expand.win() end,
    },

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

    set("v", "<leader>ghs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "[Git] Stage hunk" })
    set("v", "<leader>ghr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "[Git] Reset hunk" })
    set("n", "<leader>ghs", function() gs.stage_hunk() end, { desc = "[Git] Stage hunk" })
    set("n", "<leader>ghr", function() gs.reset_hunk() end, { desc = "[Git] Reset hunk" })
    set("n", "<leader>ghS", function() gs.stage_buffer() end, { desc = "[Git] Stage buffer" })
    set("n", "<leader>ghR", function() gs.reset_buffer() end, { desc = "[Git] Reset buffer" })
    set("n", "<leader>ghp", function() gs.preview_hunk() end, { desc = "[Git] Preview hunk" })
    set("n", "<leader>ghi", function() gs.preview_hunk_inline() end, { desc = "[Git] Preview hunk inline" })
    set("n", "<leader>ghb", function() gs.blame_line() end, { desc = "[Git] Blame line" })
    set("n", "<leader>ghd", function() gs.diffthis() end, { desc = "[Git] Diff this" })
    set("n", "<leader>ghD", function() gs.diffthis("~") end, { desc = "[Git] Diff against ~HEAD" })

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
    set("n", "gd", function() Snacks.picker.lsp_definitions() end, { buffer = buffer, desc = "Goto Definition" })
    -- Goto the declaration of the word under the cursor.
    set("n", "gD", function() Snacks.picker.lsp_declarations() end, { buffer = buffer, desc = "Goto Declaration" })
    -- Goto the implementation of the word under the cursor.
    set("n", "gI", function() Snacks.picker.lsp_implementations() end, { buffer = buffer, desc = "Goto Implementation" })
    -- Goto the definition of the type of the word under the cursor.
    set("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { buffer = buffer, desc = "Goto Type Definition" })

    -- FIND

    -- Find references of the word under the cursor.
    set("n", "gr", function() Snacks.picker.lsp_references() end, { buffer = buffer, desc = "Find References" })

    -- SEARCH

    -- Search LSP symbols in the current buffer.
    set("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { buffer = buffer, desc = "Search LSP Symbols" })
    -- Search LSP symbols in the entire workspace.
    set("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, { buffer = buffer, desc = "Search LSP Workspace Symbols" })

    -- CODE EDIT

    -- Renames all references to the symbol under the cursor.
    set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = buffer, desc = "Rename Symbol" })
    set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = buffer, desc = "Code Action" })

    -- INFORMATIONS

    -- Show hover informations about the word under the cursor.
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_hover, buffer) then
        set("n", "K", vim.lsp.buf.hover, { buffer = buffer, desc = "Hover Informations" })
    end

    -- Show signature informations about the word under the cursor.
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_signatureHelp, buffer) then
        set("n", "gK", vim.lsp.buf.signature_help, { buffer = buffer, desc = "Signature Informations" })
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
M.snacks_lazygit = function()
    local snacks = require("snacks")

    if vim.fn.executable("lazygit") then
        set("n", "<leader>gG", function() snacks.lazygit() end, { desc = "Lazygit in cwd" })
    end
end
end

-- stylua: ignore
M.snacks_picker = {
    -- Top Pickers & Explorer
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Search Buffers" },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Search Command History" },
    { "<leader>n", function() Snacks.picker.notifications() end, desc = "Search Notification History" },
    -- { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
    -- Find
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find Buffers" },
    ---@diagnostic disable-next-line: assign-type-mismatch
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Find Projects" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Find Recent" },
    -- Git
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Search Git Branches" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Search Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Search Git Log Line" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Search Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Search Git Stash" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Search Git Diff (Hunks)" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Search Git Log File" },
    -- Grep
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Grep Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Grep Visual selection or word", mode = { "n", "x" } },
    -- Search
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Search Registers" },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Search Autocmds" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Search Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Search Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Search Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Search Buffer Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Search Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Search Highlights" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Search Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Search Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Search Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Search Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Search Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Search Man Pages" },
    { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search Search for Plugin Spec" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Search Quickfix List" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Search Resume" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Search Undo History" },
}

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
    ---@diagnostic disable-next-line: undefined-field
    set("n", "<leader>st", function() Snacks.picker.todo_comments() end, { desc = "Search Todo Comments" })
    -- Fuzzy search for todo/fix/fixme comments in the entire workspace.
    ---@diagnostic disable-next-line: undefined-field
    set("n", "<leader>sT", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, { desc = "Search Todo/Fix/Fixme Comments" })

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
