require("codecompanion").setup({
	log_level = "DEBUG",
	adapters = {
		acp = {
			gemini_cli = function()
				return require("codecompanion.adapters").extend("gemini_cli", {
					defaults = {
						auth_method = "oauth-personal",
					},
					-- commands = {
					-- 	default = { "gemini", "acp" },
					-- },
				})
			end,
			opts = {
				show_presets = false,
			},
		},
	},
	strategies = {
		chat = { adapter = "gemini_cli" },
		inline = { adapter = "gemini_cli" },
		cmd = { adapter = "gemini_cli" },
	},
	interactions = {
		chat = {
			keymaps = {
				send = {
					modes = {
						n = { "<CR>", "<C-s>" }, -- Enter or Ctrl + S
						i = "<CR><C-s>", -- Ctrl + Enter
					},
					opts = {},
				},
				-- Add further custom keymaps here
			},
			slash_commands = {
				["file"] = {
					-- Use Telescope as the provider for the /file command
					opts = {
						provider = "telescope", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks"
					},
				},
			},
		},
	},
	display = {
		action_palette = {
			width = 95,
			height = 10,
			prompt = "Prompt ", -- Prompt used for interactive LLM calls
			provider = "telescope", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
			opts = {
				show_preset_actions = true, -- Show the preset actions in the action palette?
				show_preset_prompts = true, -- Show the preset prompts in the action palette?
				title = "CodeCompanion actions", -- The title of the action palette
			},
		},
	},
})

vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "<leader>ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
