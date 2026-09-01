-- Export lualine statusline plugin specification table for lazy.nvim
return {
	{
		-- Fast and easy to configure statusline plugin for Neovim
		"nvim-lualine/lualine.nvim",

		-- Icon provider for statusline components
		dependencies = { "nvim-tree/nvim-web-devicons" },

		-- Load immediately during startup so the statusline renders with colorscheme
		event = "VeryLazy",

		-- Configuration function executed after loading lualine
		config = function()
			-- Safely import lualine module
			local lualine = require("lualine")

			-- Helper to extract active LSP server names attached to current buffer
			local function lsp_status()
				local msg = "No Active LSP"
				local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
				local clients = vim.lsp.get_clients({ bufnr = 0 })
				if next(clients) == nil then
					return msg
				end
				local client_names = {}
				for _, client in ipairs(clients) do
					table.insert(client_names, client.name)
				end
				return table.concat(client_names, ", ")
			end

			-- Initialize lualine setup options
			lualine.setup({
				options = {
					-- Apply the matching Nord colorscheme to the statusline
					theme = "nord",

					-- Powerline rounded separators for a modern aesthetic
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },

					-- Disable statusline on specific utility filetypes
					disabled_filetypes = {
						statusline = { "lazy", "mason", "oil" },
						winbar = {},
					},

					-- Use global statusline across all window splits
					globalstatus = true,
				},

				-- Configure statusline content across sections A through Z
				sections = {
					-- Section A: Current editor mode (NORMAL, INSERT, VISUAL)
					lualine_a = { { "mode", separator = { left = " " }, right_padding = 2 } },

					-- Section B: Active Git branch
					lualine_b = { "branch" },

					-- Section C: File name and path + Git diff status
					lualine_c = {
						{
							"filename",
							path = 1, -- Relative path display
						},
						{
							"diff",
							symbols = { added = " ", modified = " ", removed = " " },
						},
					},

					-- Section X: LSP diagnostics counters
					lualine_x = {
						{
							"diagnostics",
							sources = { "nvim_diagnostic" },
							symbols = { error = " ", warn = " ", info = " ", hint = "󰠠 " },
						},
						-- Custom active LSP server indicator component
						{
							lsp_status,
							icon = " ",
							color = { fg = "#88C0D0" },
						},
						-- File format and encoding
						"encoding",
						"filetype",
					},

					-- Section Y: Progress percentage in file
					lualine_y = { "progress" },

					-- Section Z: Cursor position (line:column)
					lualine_z = { { "location", separator = { right = " " }, left_padding = 2 } },
				},

				-- Fallback configuration when a window is inactive
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
			})
		end,
	},
}
