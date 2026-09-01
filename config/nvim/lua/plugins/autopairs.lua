-- Export autopairs plugin specification table for lazy.nvim
return {
	{
		-- Powerful autopair plugin for Neovim with treesitter and cmp integration
		"windwp/nvim-autopairs",

		-- Load plugin automatically upon entering insert mode
		event = "InsertEnter",

		-- Hook into nvim-cmp to close brackets automatically on completion confirms
		dependencies = {
			"hrsh7th/nvim-cmp",
		},

		-- Configuration function executed after loading autopairs
		config = function()
			-- Safely import nvim-autopairs module
			local autopairs = require("nvim-autopairs")

			-- Initialize autopairs with Treesitter node awareness
			autopairs.setup({
				-- Enable treesitter check to avoid closing pairs inside strings or comments
				check_ts = true,

				-- Language-specific treesitter node exclusions
				ts_config = {
					lua = { "string" }, -- Don't add pairs inside lua string treesitter nodes
					javascript = { "template_string" }, -- Don't add pairs inside JS template strings
					java = false, -- Don't check treesitter on java
				},

				-- Fast wrap feature keybindings (Alt + e)
				fast_wrap = {
					map = "<C-e>",
					chars = { "{", "[", "(", '"', "'" },
					pattern = [=[[%'%"%>%]%)%}%,]]=],
					end_key = "$",
					before_key = "h",
					after_key = "l",
					cursor_pos_before = true,
					keys = "qwertyuiopzxcvbnmasdfghjkl",
					manual_position = true,
					highlight = "Search",
					highlight_grey = "Comment",
				},
			})

			-- Import nvim-cmp integration module safely
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")

			-- Automatically insert parentheses after selecting a function/method from nvim-cmp
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
}
