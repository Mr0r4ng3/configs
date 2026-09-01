-- Set leader key to space (must be set before loading plugins)
vim.g.mapleader = " "

-- Set local leader key to space
vim.g.maplocalleader = " "

-- Create a local shorthand reference to Neovim options
local opt = vim.opt

-- Show absolute line number for the current line
opt.number = true

-- Show relative line numbers for all other lines to simplify jumps
opt.relativenumber = true

-- Render tab characters as 2 visual columns
opt.tabstop = 4

-- Insert 2 spaces when indenting with >> or << operations
opt.shiftwidth = 4

-- Convert tab key presses into whitespace characters automatically
opt.expandtab = true

-- Copy indent level from the current line when creating a new line
opt.autoindent = true

-- Apply syntax-aware smart indentation based on filetype rules
opt.smartindent = true

-- Prevent long lines from breaking into visually wrapped lines
opt.wrap = true

-- Make search patterns case-insensitive by default
opt.ignorecase = true

-- Override ignorecase if search pattern contains uppercase characters
opt.smartcase = true

-- Highlight all matching results when performing a search
opt.hlsearch = true

-- Show incremental search matches live as you type the pattern
opt.incsearch = true

-- Enable 24-bit RGB true colors in modern terminal emulators
opt.termguicolors = true

-- Always display the sign column to prevent lateral layout shifts
opt.signcolumn = "yes"

-- Visually highlight the entire line where the cursor is positioned
opt.cursorline = true

-- Keep at least 8 screen lines visible above and below the cursor
opt.scrolloff = 8

-- Keep at least 8 screen columns visible to the left and right
opt.sidescrolloff = 8

-- Disable default mode message display, handled by lualine
opt.showmode = false

-- Synchronize register operations with the OS system clipboard
opt.clipboard = "unnamedplus"

-- Enable mouse support across normal, visual, insert, and command modes
opt.mouse = "a"

-- Force horizontal splits to automatically open below the active window
opt.splitbelow = true

-- Force vertical splits to automatically open to the right of the active window
opt.splitright = true

-- Disable the creation of swap files in the working directory
opt.swapfile = false

-- Prevent creation of temporary backup files before writing buffers
opt.backup = false

-- Persist complete undo history to disk across editor restarts
opt.undofile = true

-- Decrease idle event delay to 250ms for faster diagnostic refreshes
opt.updatetime = 250

-- Wait up to 300ms for completing a mapped sequence before timing out
opt.timeoutlen = 300
