-- Export gitsigns plugin specification table for lazy.nvim
return {
	{
		-- Super fast Git decorations and buffer integration written in pure Lua
		"lewis6991/gitsigns.nvim",

		-- Load plugin when opening an existing buffer or reading a file
		event = { "BufReadPre", "BufNewFile" },

		-- Plugin configuration function executed after loading gitsigns
		config = function()
			-- Safely import gitsigns module
			local gitsigns = require("gitsigns")

			-- Initialize gitsigns configuration options
			gitsigns.setup({
				-- Configure visual sign indicators in the gutter/signcolumn
				signs = {
					add = { text = "│" },
					change = { text = "│" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},

				-- Enable sign column indicators
				signcolumn = true,

				-- Highlight line number corresponding to Git status
				numhl = false,

				-- Highlight entire line (disabled to avoid visual clutter)
				linehl = false,

				-- Configure line blame annotations at end of cursor line
				current_line_blame = false, -- Toggle with <leader>gb
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
					delay = 500,
					ignore_whitespace = false,
				},
				current_line_blame_formatter = "   <author>, <author_time:%R> • <summary>",

				-- Configure visual preview popup window
				preview_config = {
					border = "rounded",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},

				-- Configure buffer-local keybindings when gitsigns attaches
				on_attach = function(bufnr)
					-- Helper function for normal mode key mapping
					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation between modified hunks
					-- [g + c + n] -> Jump to next modified Git hunk
					map("n", "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gitsigns.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, desc = "Git: Jump to next hunk" })

					-- [g + c + p] -> Jump to previous modified Git hunk
					map("n", "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gitsigns.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, desc = "Git: Jump to previous hunk" })

					-- Actions: Staging, Resetting, and Previewing
					-- [Space + h + s] -> Stage current hunk (Normal and Visual mode)
					map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Git: Stage hunk" })
					map("v", "<leader>hs", function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Git: Stage selected hunk" })

					-- [Space + h + r] -> Reset current hunk (discard changes in hunk)
					map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Git: Reset hunk" })
					map("v", "<leader>hr", function()
						gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Git: Reset selected hunk" })

					-- [Space + h + S] -> Stage entire buffer
					map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Git: Stage entire buffer" })

					-- [Space + h + R] -> Reset entire buffer (discard all local changes)
					map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Git: Reset entire buffer" })

					-- [Space + h + u] -> Undo last staged hunk
					map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Git: Undo stage hunk" })

					-- [Space + h + p] -> Preview diff for hunk under cursor in popup
					map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Git: Preview hunk diff" })

					-- [Space + h + b] -> View git blame for current line in popup
					map("n", "<leader>hb", function()
						gitsigns.blame_line({ full = true })
					end, { desc = "Git: Blame line popup" })

					-- [Space + g + b] -> Toggle inline virtual text blame annotation
					map("n", "<leader>gb", gitsigns.toggle_current_line_blame, { desc = "Git: Toggle inline blame" })

					-- [Space + h + d] -> Open full diff against index
					map("n", "<leader>hd", gitsigns.diffthis, { desc = "Git: Diff this buffer" })

					-- Text object: Select hunk with 'ih' (e.g., 'dih' to delete hunk, 'yih' to yank hunk)
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git: Select hunk" })
				end,
			})
		end,
	},
}
