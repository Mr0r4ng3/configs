-- Export Snacks.nvim plugin specification table for lazy.nvim
return {
	{
		-- Collection of small, high-performance QoL plugins for Neovim by Folke
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,

		-- Module configuration options
		opts = {
			-- Ultra-fast fuzzy finder and Command Palette
			picker = {
				enabled = true,
			},
			-- Integrated floating LazyGit instance
			lazygit = {
				enabled = true,
			},
			-- Smooth indent guides
			indent = {
				enabled = true,
			},
			-- Fast buffer delete without messing up split layouts
			bufdelete = {
				enabled = true,
			},
		},

		-- Centralized keybindings for Snacks modules
		keys = {
			-- Command Palette & Quick Discovery (VS Code style)
			{
				"<leader><leader>",
				function()
					Snacks.picker.commands()
				end,
				desc = "Command Palette (All Commands)",
			},
			{
				"<leader>fk",
				function()
					Snacks.picker.keymaps()
				end,
				desc = "Find Keymaps",
			},

			-- Fuzzy Finder (Files, Buffers, Text)
			{
				"<leader>ff",
				function()
					Snacks.picker.files()
				end,
				desc = "Find Files",
			},
			{
				"<leader>fg",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep (Search Text)",
			},
			{
				"<leader>fb",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Find Buffers",
			},
			{
				"<leader>fh",
				function()
					Snacks.picker.help()
				end,
				desc = "Help Tags",
			},

			-- Code & LSP Navigation
			{
				"gr",
				function()
					Snacks.picker.lsp_references()
				end,
				desc = "LSP References",
			},
			{
				"gd",
				function()
					Snacks.picker.lsp_definitions()
				end,
				desc = "LSP Definitions",
			},
			{
				"<leader>ss",
				function()
					Snacks.picker.lsp_symbols()
				end,
				desc = "LSP Document Symbols",
			},

			-- Git Integration via Snacks
			{
				"<leader>lg",
				function()
					Snacks.lazygit()
				end,
				desc = "Open LazyGit",
			},
			{
				"<leader>lf",
				function()
					Snacks.lazygit.log_file()
				end,
				desc = "LazyGit Current File History",
			},

			{
				"<leader>bd",
				function()
					Snacks.bufdelete()
				end,
				desc = "Delete Buffer (Preserve Window Layout)",
			},
		},
	},
}
