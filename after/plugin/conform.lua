local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" }, -- Install with `cargo install stylua`
		-- Conform will run multiple formatters sequentially
		python = { "black" },
		-- Use a sub-list to run only the first available formatter
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		rust = { "rustfmt" },
		go = { "gofmt" },
	},
})
