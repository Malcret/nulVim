-- CUSTOM GLOBALS

-- Choose between `catppuccin` and `tokyonight`
-- vim.g.colorscheme = "tokyonight"
vim.g.colorscheme = "catppuccin"
-- Set column limit, set to 0 to disable.
vim.g.columnlimit = 120
-- Show column limit.
vim.g.showcolumnlimit = true

vim.g.codelens = false
vim.g.inlayhints = false

-- APPEARANCE

-- If in Insert, Replace or Visual mode put a message on the last line.
vim.opt.showmode = false
-- Enables 24-bit RGB color in the TUI.
vim.opt.termguicolors = true
-- The value of this option influences when the last window will have a status line.
-- See `:help laststatus` for valid values.
vim.opt.laststatus = 3

-- Hard-wrap to $MANWIDTH or window width if $MANWIDTH is empty.
-- Use 1 and 0 insteed of true or false.
-- vim.g.man_hardwrap = 0

-- CLIPBOARD

-- Sync the clipboard between Neovim and the OS.
-- Schedule the setting after 'UiEnter' because it can increase startup-time.
vim.schedule(function() vim.opt.clipboard = "unnamedplus" end)

-- COLUMN

-- Print the line number in front of each line.
vim.opt.number = true
-- Show the line number relative to the line with the cursor in front of each line.
vim.opt.relativenumber = true
-- When and how to draw the signcolumn.
-- See ':help signcolumn' for valid values.
vim.opt.signcolumn = "yes"
-- Highlight column.
if vim.g.showcolumnlimit then vim.opt.colorcolumn = { vim.g.columnlimit } end

-- CURSOR

-- Highlight the text line of the cursor with CursorLine 'hl-CursorLine'.
vim.opt.cursorline = true
-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8
-- Minimal number of screen lines to keep right to the cursor.
vim.opt.sidescrolloff = 8

-- FOLD

vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- FORMATING

vim.opt.formatexpr = "v:lua.require'utils.format'.formatexpr()"
-- Default: "tcqj"
vim.opt.formatoptions = "croqlnt"

-- GREP

vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"

-- IDENTATION

-- vim.opt.indentkeys = ""
vim.opt.indentexpr = "v:lua.require'utils.format'.indentexpr(v:lnum)"
-- Copy indent from current line when starting a new line.
vim.opt.autoindent = true
-- Do smart autoindenting when starting a new line.
vim.opt.smartindent = true
-- In Insert mode: Use the appropriate number of spaces to insert a <Tab>.
-- Spaces are used in indents with the '>' and '<' commands and when 'autoindent' is on.
vim.opt.expandtab = true
-- When on, a <Tab> in front of a line inserts blanks according to 'shiftwidth'.
vim.opt.smarttab = true
-- Number of spaces that a <Tab> in the file counts for.
-- See ':help tabstop' for more informations on tab behavior.
vim.opt.tabstop = 8
-- Number of spaces to use for each step of (auto)indent.
vim.opt.shiftwidth = 4
-- Number of spaces that a <Tab> counts for while performing editing operations, like inserting a <Tab> or using <BS>.
-- It "feels" like <Tab>s are being inserted, while in fact a mix of spaces and <Tab>s is used.
vim.opt.softtabstop = 4
-- Round indent to multiple of 'shiftwidth'.
vim.opt.shiftround = true

-- MOUSE

-- Enables mouse support.
-- See ':help mouse' for valid values.
vim.opt.mouse = "a"

-- SEARCH & SUBSTITUTE

-- When there is a previous search pattern, highlight all its matches.
vim.opt.hlsearch = true
-- When nonempty, shows the effects of ':substitute', ':smagic', ':snomagic' and user commands with the
-- ':command-preview' flag as you type.
-- See ':help inccommand' for valid values.
vim.opt.inccommand = "split"
-- Ignore case in search patterns.
vim.opt.ignorecase = true
-- Override the 'ignorecase' option if the search pattern contains upper case characters.
-- Only used when the search pattern is typed and 'ignorecase' option is on.
vim.opt.smartcase = true

-- SAVE

-- Write the contents of the file, if it has been modified.
-- See `:help autowrite` for more info.
vim.opt.autowrite = true

-- SPLIT

-- When on, splitting a window will put the new window below the current one.
vim.opt.splitbelow = true
-- When on, splitting a window will put the new window right of the current one.
vim.opt.splitright = true

-- TIME

-- This option and 'timeoutlen' determine the behavior when part of a mapped key sequence has been received.
vim.opt.timeout = true
-- Time in milliseconds to wait for a mapped sequence to complete.
vim.opt.timeoutlen = 300
-- If this many milliseconds nothing is typed the swap file will be written to disk (see 'crash-recovery'). Also used
-- for the 'CursorHold' autocommand event.
vim.opt.updatetime = 250

-- UNDO

-- When on, Vim automatically saves undo history to an undo file when writing a buffer to a file, and restores undo
-- history from the same file on buffer read.
vim.opt.undofile = true

-- WHITESPACES

-- List mode: By default, show tabs as ">", trailing spaces as "-", and non-breakable space characters as "+".
vim.opt.list = true
-- Strings to use in 'list' mode and for the ':list' command.
-- See ':help listchars' for valid values.
vim.opt.listchars = { tab = "»", trail = "·", nbsp = "␣" }

-- WRAP

-- Maximum width of text that is being inserted. A longer line will be broken after white space to get this width.
-- A zero value disables this.
vim.o.textwidth = 120
-- Every wrapped line will continue visually indented (same amount of space as the beginning of that line),
-- thus preserving horizontal blocks of text.
vim.opt.breakindent = true
-- When on, lines longer than the width of the window will wrap and displaying continues on the next line.
vim.opt.wrap = true
