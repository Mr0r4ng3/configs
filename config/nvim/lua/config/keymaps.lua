-- Create a local shorthand reference for the keymap setting function
local map = vim.keymap.set

-- [Esc] -> Clear search highlights in normal mode
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- [Leader + w] -> Save the current file
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save current file" })

-- [Leader + q] -> Close the active window / buffer
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit active window" })

-- [Leader + Q] -> Force quit all windows without saving
map("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Force quit all" })

-- [Visual: J] -> Move selected lines down one row and reselect
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })

-- [Visual: K] -> Move selected lines up one row and reselect
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- [Ctrl + d] -> Scroll down half page and center cursor
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center cursor" })

-- [Ctrl + u] -> Scroll up half page and center cursor
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center cursor" })

-- [n] -> Jump to next search match and center screen
map("n", "n", "nzzzv", { desc = "Next search match and center" })

-- [N] -> Jump to previous search match and center screen
map("n", "N", "Nzzzv", { desc = "Previous search match and center" })

-- [Visual: Leader + p] -> Paste over selection without replacing clipboard content
map("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting clipboard register" })

-- [Leader + d] -> Delete text into black hole register (keeps clipboard intact)
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking to register" })

-- [Ctrl + h] -> Move focus to the split window on the left
map("n", "<C-h>", "<C-w>h", { desc = "Navigate to left window" })

-- [Ctrl + j] -> Move focus to the split window below
map("n", "<C-j>", "<C-w>j", { desc = "Navigate to lower window" })

-- [Ctrl + k] -> Move focus to the split window above
map("n", "<C-k>", "<C-w>k", { desc = "Navigate to upper window" })

-- [Ctrl + l] -> Move focus to the split window on the right
map("n", "<C-l>", "<C-w>l", { desc = "Navigate to right window" })

-- [Leader + |] -> Split the active window vertically
map("n", "<leader>|", "<cmd>vsplit<CR>", { desc = "Split window vertically" })

-- [Leader + -] -> Split the active window horizontally
map("n", "<leader>-", "<cmd>split<CR>", { desc = "Split window horizontally" })

-- [Ctrl + Up Arrow] -> Increase current window height by 2 lines
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })

-- [Ctrl + Down Arrow] -> Decrease current window height by 2 lines
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })

-- [Ctrl + Left Arrow] -> Decrease current window width by 2 columns
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })

-- [Ctrl + Right Arrow] -> Increase current window width by 2 columns
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- [Visual: >] -> Indent selection to the right and keep selection active
map("v", ">", ">gv", { desc = "Indent right and keep selection" })

-- [Visual: <] -> Indent selection to the left and keep selection active
map("v", "<", "<gv", { desc = "Indent left and keep selection" })

---- Lazy ----
-- [Space + l] -> Open Lazy plugin manager interface
map("n", "<leader>l", "<cmd>Lazy<CR>", { desc = "Open Lazy UI" })
