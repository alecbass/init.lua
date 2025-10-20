local conform = require("conform")

conform.setup({
	formatters_by_ft = {
        html = { "djlint" },
		lua = { "stylua" }, -- Install with `cargo install stylua`
		-- Conform will run multiple formatters sequentially
		python = { "ruff" },
		-- Use a sub-list to run only the first available formatter
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		rust = { "rustfmt" },
		go = { "gofmt" },
		terraform = { "terraform_fmt" },
		tf = { "terraform_fmt" },
		["terraform-vars"] = { "terraform_fmt" },
		c = { "clang-format" },
		cpp = { "clang-format" },
	},
})

conform.formatters.djlint = {
    append_args = { "--reformat" } -- Save the file after format
}
