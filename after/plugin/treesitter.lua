local nvim_treesitter = require("nvim-treesitter")

nvim_treesitter.setup({
	-- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
	install_dir = vim.fn.stdpath("data") .. "/site",
})

nvim_treesitter.install({
	"lua",
	"vim",
	"vimdoc",
	"javascript",
	"typescript",
	"c",
	"cpp",
	"rust",
	"python",
	"jsx",
	"tsx",
	"go",
})
