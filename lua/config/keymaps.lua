---@class nulVim.config.keymaps
local M = {}

local map = nulVim.map

-- WICH-KEY GROUPS

M.wich_key = {
  mode = { "n", "v" },

  -- Groups
  { "<leader>c", group = "Code" },
  { "<leader>d", group = "Debug" },
  { "<leader>f", group = "File/Find" },
  { "<leader>g", group = "Git" },
  { "<leader>gh", group = "Hunk" },
  { "<leader>q", group = "Quit" },
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
  {
    "<leader>?",
    function() require("which-key").show({ global = false }) end,
    desc = "Show Buffer Keymaps",
  },
}

-- NVIM

M.nvim = function()
  -- BUFFERS

  map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
  map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
  map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
  map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
  map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
  map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
  map("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
  map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

  -- COMMENTS

  map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
  map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

  -- DIAGNOSTICS

  local diagnostic_goto = function(count, severity)
    local go = vim.diagnostic.jump
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function() go({ count = count, severity = severity }) end
  end
  map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
  map("n", "]d", diagnostic_goto(1), { desc = "Next Diagnostic" })
  map("n", "[d", diagnostic_goto(-1), { desc = "Prev Diagnostic" })
  map("n", "]e", diagnostic_goto(1, "ERROR"), { desc = "Next Error" })
  map("n", "[e", diagnostic_goto(-1, "ERROR"), { desc = "Prev Error" })
  map("n", "]w", diagnostic_goto(1, "WARN"), { desc = "Next Warning" })
  map("n", "[w", diagnostic_goto(-1, "WARN"), { desc = "Prev Warning" })

  -- DISABLE

  -- Disable "s" key default behavior.
  map({ "n", "x" }, "s", "<Nop>")
  -- Disable <space> key default behavior.
  map("n", "<space>", "<Nop>")

  -- FILE

  -- TODO: improve this
  -- Create a new file.
  map("n", "<leader>fn", function()
    vim.cmd.enew()
    -- FIX: completion with blink.cmp doesn't trigger well on vim.ui.input, so vim.fn.input is use for now
    -- vim.ui.input({ prompt = "Enter new file path: " }, function(input) vim.cmd.write({ args = { input } }) end)
    vim.cmd.write({ args = { vim.fn.input("Enter new file path: ", "", "file") } })
  end, { desc = "New File" })

  -- LAZY.NVIM

  map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

  -- LOCATION LIST

  map("n", "<leader>xl", function()
    local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
    if not success and err then vim.notify(err, vim.log.levels.ERROR) end
  end, { desc = "Location List" })

  -- MOTIONS

  -- Disable arrow keys in normal mode.
  map("n", "<left>", "<cmd>echo 'Use h to move!!'<CR>")
  map("n", "<right>", "<cmd>echo 'Use l to move!!'<CR>")
  map("n", "<up>", "<cmd>echo 'Use k to move!!'<CR>")
  map("n", "<down>", "<cmd>echo 'Use j to move!!'<CR>")

  -- Better `h` and `j` navigation.
  map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
  map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

  -- Move Lines.
  map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Line Down" })
  map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Line Up" })
  map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Line Down" })
  map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Line Up" })
  map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Lines Down" })
  map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Lines Up" })

  -- QUICKFIX LIST

  map("n", "<leader>xq", function()
    local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
    if not success and err then vim.notify(err, vim.log.levels.ERROR) end
  end, { desc = "Quickfix List" })

  map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
  map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

  -- SOURCE

  map(
    "n",
    "<leader>cx",
    vim.bo.filetype == "lua" and "<cmd>.lua<cr>" or "<cmd>echo 'Not a Lua file!'",
    { desc = "Source Lua Line" }
  )
  map(
    "v",
    "<leader>cx",
    vim.bo.filetype == "lua" and "<cmd>lua<cr>" or "<cmd>echo 'Not a Lua file!'",
    { desc = "Source Lua Code" }
  )
  map(
    "n",
    "<leader>cX",
    vim.bo.filetype == "lua" and "<cmd>source %<cr>" or "<cmd>echo 'Not a Lua file!'",
    { desc = "Source Lua File" }
  )

  -- TERMINAL

  -- Better keybind to quit terminal mode.
  -- See ':help terminal'.
  map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit termional mode" })

  -- TABS

  map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
  map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
  map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
  map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
  map("n", "[<tab>", "<cmd>tabprev<cr>", { desc = "Previous Tab" })
  map("n", "]<tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
  map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })

  -- UTILS

  -- Clear highlights on search when pressing <Esc> in normal mode.
  -- See ':help hlsearch'.
  map("n", "<Esc>", "<cmd>nohlsearch<CR>")

  -- Quit Neovim
  map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

  -- WINDOWS

  -- Better keybinds for window navigation.
  map("n", "<C-h>", "<C-w><C-h>", { desc = "Go to Left Window" })
  map("n", "<C-l>", "<C-w><C-l>", { desc = "Go to Right Window" })
  map("n", "<C-j>", "<C-w><C-j>", { desc = "Go to Lower Window" })
  map("n", "<C-k>", "<C-w><C-k>", { desc = "Go to Upper Window" })

  -- Resize window using <ctrl> arrow keys
  map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
  map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
  map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
  map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

  map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
  map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
  map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
end

-- CONFORM

M.conform = {
  -- FORMATTING

  -- Format the current buffer using conform.
  {
    "<leader>cf",
    function() require("conform").format({ async = true }) end,
    mode = { "n", "v" },
    desc = "Format Buffer",
  },
}

-- DAP

M.dap = {
  {
    "<leader>dB",
    function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
    desc = "[DAP] Breakpoint Condition",
  },
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
  {
    "<leader>du",
    function() require("dapui").toggle() end,
    desc = "[DAP] Toggle UI",
  },
  {
    "<leader>de",
    function() require("dapui").eval() end,
    desc = "[DAP] Eval",
    mode = { "n", "v" },
  },
}

-- FLASH

M.flash = {
  { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "[Flash] Jump" },
  { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "[Flash] Treesitter" },
  { "r", mode = "o", function() require("flash").remote() end, desc = "[Flash] Remote" },
  { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "[Flash] Treesitter Search" },
  { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "[Flash] Toggle Search" },
}

-- GITSIGNS

---@param buffer integer
M.gitsigns = function(buffer)
  local gs = require("gitsigns")

  -- NAVIGATION

  map("n", "]c", function()
    if vim.wo.diff then
      vim.cmd.normal({ "]c", bang = true })
    else
      gs.nav_hunk("next")
    end
  end, { buffer = buffer, desc = "Next Hunk" })
  map("n", "[c", function()
    if vim.wo.diff then
      vim.cmd.normal({ "[c", bang = true })
    else
      gs.nav_hunk("prev")
    end
  end, { buffer = buffer, desc = "Prev Hunk" })
  map("n", "]H", function() gs.nav_hunk("last") end, { desc = "Last Hunk" })
  map("n", "[H", function() gs.nav_hunk("first") end, { desc = "First Hunk" })

  -- ACTIONS

  map({ "n", "v" }, "<leader>ghs", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage Hunk" })
  map({ "n", "v" }, "<leader>ghr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset Hunk" })
  map("n", "<leader>ghS", function() gs.stage_buffer() end, { desc = "Stage Buffer" })
  map("n", "<leader>ghR", function() gs.reset_buffer() end, { desc = "Reset Buffer" })
  map("n", "<leader>ghp", function() gs.preview_hunk() end, { desc = "Preview Hunk" })
  map("n", "<leader>ghi", function() gs.preview_hunk_inline() end, { desc = "Preview Hunk Inline" })
  map("n", "<leader>ghb", function() gs.blame_line() end, { desc = "Blame Line" })
  map("n", "<leader>ghd", function() gs.diffthis() end, { desc = "Diff This" })
  map("n", "<leader>ghD", function() gs.diffthis("~") end, { desc = "Diff This ~HEAD" })

  -- TOGGLE

  map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle Line Blame" })
  map("n", "<leader>tw", gs.toggle_word_diff, { desc = "Toggle Word Diff" })
end

-- LSP

---@param buffer integer
---@param client? vim.lsp.Client
M.lsp = function(buffer, client)
  -- GOTO

  -- Goto the definition of the word under the cursor.
  map("n", "gd", function() Snacks.picker.lsp_definitions() end, { buffer = buffer, desc = "Goto Definition" })
  -- Goto the declaration of the word under the cursor.
  map("n", "gD", function() Snacks.picker.lsp_declarations() end, { buffer = buffer, desc = "Goto Declaration" })
  -- Goto the implementation of the word under the cursor.
  map("n", "gI", function() Snacks.picker.lsp_implementations() end, { buffer = buffer, desc = "Goto Implementation" })
  -- Goto the definition of the type of the word under the cursor.
  map(
    "n",
    "gy",
    function() Snacks.picker.lsp_type_definitions() end,
    { buffer = buffer, desc = "Goto Type Definition" }
  )

  -- FIND

  -- Find references of the word under the cursor.
  map("n", "gr", function() Snacks.picker.lsp_references() end, { buffer = buffer, desc = "Find References" })

  -- SEARCH

  -- Search LSP symbols in the current buffer.
  map("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { buffer = buffer, desc = "Search LSP Symbols" })
  -- Search LSP symbols in the entire workspace.
  map(
    "n",
    "<leader>sS",
    function() Snacks.picker.lsp_workspace_symbols() end,
    { buffer = buffer, desc = "Search LSP Workspace Symbols" }
  )

  -- CODE ACTIONS

  -- Renames all references to the symbol under the cursor.
  if nulVim.lsp.has_method(buffer, client, "rename") then
    map("n", "<leader>cr", vim.lsp.buf.rename, { buffer = buffer, desc = "Rename Symbol" })
  end
  -- Show available code actions.
  if nulVim.lsp.has_method(buffer, client, "codeAction") then
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = buffer, desc = "Code Action" })
  end
  -- Codelens
  if vim.g.codelens and nulVim.lsp.has_method(buffer, client, "codeLens") then
    map({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run, { buffer = buffer, desc = "Run Codelens" })
    map("n", "<leader>cC", vim.lsp.codelens.refresh, { buffer = buffer, desc = "Refresh Codelens" })
  end

  -- INFORMATIONS

  -- Show hover informations about the word under the cursor.
  if nulVim.lsp.has_method(buffer, client, "hover") then
    map("n", "K", vim.lsp.buf.hover, { buffer = buffer, desc = "Hover Informations" })
  end

  -- Show signature informations about the word under the cursor.
  if nulVim.lsp.has_method(buffer, client, "signatureHelp") then
    map("n", "gK", vim.lsp.buf.signature_help, { buffer = buffer, desc = "Signature Informations" })
  end

  -- Show diagnostics under the cursor.
  map(
    "n",
    "<leader>xd",
    function() vim.diagnostic.open_float({ scope = "cursor" }) end,
    { buffer = buffer, desc = "Show Diagnostics Under Cursor" }
  )
  map(
    "n",
    "<leader>xD",
    function() vim.diagnostic.open_float({ scope = "line" }) end,
    { buffer = buffer, desc = "Show Line Diagnostics" }
  )

  -- SERVER

  -- Restart LSP server
  map("n", "<leader>clr", "<cmd>LspRestart<cr>", { buffer = buffer, desc = "Restart LSP" })
  -- Show LSP server informations.
  map("n", "<leader>cli", "<cmd>LspInfo<cr>", { buffer = buffer, desc = "LSP Info" })
end

-- MASON

M.mason = {
  { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
}

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

-- OIL

M.oil = {
  { "<leader>.", function() require("oil").open(nil, { preview = { vertical = true } }) end, desc = "File Explorer" },
  {
    "<leader>e",
    function() require("oil").open(vim.uv.cwd(), { preview = { vertical = true } }) end,
    desc = "File Explorer",
  },
}

-- SNACKS

M.snacks_lazygit = function()
  if vim.fn.executable("lazygit") then
    -- set("n", "<leader>gg", function() Snacks.lazygit({ cwd = LazyVim.root.git() }) end, { desc = "Lazygit (Root Dir)" })
    map("n", "<leader>gG", function() Snacks.lazygit() end, { desc = "Lazygit (cwd)" })
  end
end

M.snacks_picker = {
  -- Top Pickers
  { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
  { "<leader>,", function() Snacks.picker.buffers() end, desc = "Search Buffers" },
  { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
  { "<leader>:", function() Snacks.picker.command_history() end, desc = "Search Command History" },
  { "<leader>n", function() Snacks.picker.notifications() end, desc = "Search Notification History" },
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
  {
    "<leader>sw",
    function() Snacks.picker.grep_word() end,
    desc = "Grep Visual selection or word",
    mode = { "n", "x" },
  },
  -- Search
  { '<leader>s"', function() Snacks.picker.registers() end, desc = "Search Registers" },
  { "<leader>s/", function() Snacks.picker.search_history() end, desc = "Search Search History" },
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
  map("n", "<leader>tt", function() Snacks.terminal() end, { desc = "Toggle terminal" })
end

-- TODO-COMMENTS

M.todo_comments = function()
  local tc = require("todo-comments")

  -- GOTO

  -- Jump to the next todo comment in the current buffer.
  map("n", "]t", tc.jump_next, { desc = "Next Todo Comment" })
  -- Jump to the previous todo comment in the current buffer.
  map("n", "[t", tc.jump_prev, { desc = "Previous Todo Comment" })

  -- FUZZY SEARCH

  -- Fuzzy search for todo comments in the entire workspace.
  ---@diagnostic disable-next-line: undefined-field
  map("n", "<leader>st", function() Snacks.picker.todo_comments() end, { desc = "Search Todo Comments" })
  -- Fuzzy search for todo/fix/fixme comments in the entire workspace.
  ---@diagnostic disable-next-line: undefined-field
  map(
    "n",
    "<leader>sT",
    ---@diagnostic disable-next-line: undefined-field
    function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end,
    { desc = "Search Todo/Fix/Fixme Comments" }
  )

  -- TROUBLE

  -- Show todo comments in the Trouble window.
  map("n", "<leader>xt", "<cmd>Trouble todo toggle<cr>", { desc = "[Trouble] Todo Comments" })
  -- Show todo/fix/fixme comments in the Trouble window.
  map(
    "n",
    "<leader>xT",
    "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
    { desc = "[Trouble] Todo/Fix/Fixme Comments" }
  )
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
  { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "[Trouble] Quickfix list" },
}

return M
