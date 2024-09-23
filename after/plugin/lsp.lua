local lsp = require("lsp-zero")
local lspconfig = require("lspconfig")

local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()

local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
		["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
		["<Enter>"] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete(),
		["<Tab>"] = nil,
		["<S-Tab>"] = nil,
	}),
})

local conform = require("conform")

lsp.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp.default_keymaps({ buffer = bufnr })

	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "gd", function()
		vim.lsp.buf.definition()
	end, opts)
	vim.keymap.set("n", "<leader>f", function()
		conform.format({ bufnr = bufnr })
	end, opts)
	vim.keymap.set("n", "<leader><F2>", function()
		vim.lsp.buf.rename()
	end, opts)
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)

	-- Set up autoformatting
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = "*",
		callback = function(args)
			-- conform.format({ bufnr = args.buf })
			-- vim.lsp.buf.format()
		end,
	})
end)

lspconfig.opts = {
	inlay_hints = {
		enabled = true,
	},
}

---
-- Replace these language servers
-- with the ones you have installed in your system
---
lspconfig.eslint.setup({})
-- Python

-- https://github.com/microsoft/pyright/blob/main/docs/configuration.md
lspconfig.pyright.setup({
	settings = {
		python = {
			analysis = {
				reportWildcardImportFromLibrary = "none",
				reportUnknownMemberType = "none",
			},
		},
	},
})

lspconfig.ruff_lsp.setup({
	on_attach = function(client, bufnr)
		client.server_capabilities.hoverProvider = false
	end,
	init_options = {
		settings = {
			-- Any extra CLI arguments for `ruff` go here.
			args = {
				"--line-length=120",
			},
			organizeImports = false,
			["lint.run"] = "onSave",
		},
	},
})

--lsp.format_on_save({
--  format_opts = {
--    async = false,
--    timeout_ms = 10000,
--  },
--  servers = {
--    ['tsserver'] = {'javascript', 'typescript'},
--    ['rust_analyzer'] = {'rust'},
--  }
--})

--
-- JavaScript / TypeScript
--
--

-- lspconfig.configs.vtsls = require("vtsls").lspconfig

lspconfig.vtsls.setup({
	settings = {
		typescript = {
			inlayHints = {
				parameterNames = { enabled = "literals" },
				parameterTypes = { enabled = true },
				variableTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				enumMemberValues = { enabled = true },
			},
		},
	},
})

--
-- Rust
--

lspconfig.rust_analyzer.setup({})

--
-- Go
--

lspconfig.gopls.setup({})

--
-- Diagnostic Language Server
--
local eslint = require("diagnosticls-configs.linters.eslint")
local prettier = require("diagnosticls-configs.formatters.prettier")
local black = require("diagnosticls-configs.formatters.black")
local luacheck = require("diagnosticls-configs.linters.luacheck")

lspconfig.diagnosticls.setup({
	filetypes = { "*" },
	init_options = {
		linters = {
			ligma = {
				command = "/Users/nickhenderson/Projects/Ligma/ligma.py",
				sourceName = "python3",
				args = { "%filepath" },
				formatPattern = {
					"^(\\d+):(\\d+):(\\d+):([^:]+):([^:]+)$",
					{
						line = 1,
						column = 2,
						endColumn = 3,
						security = 4,
						message = 5,
					},
				},
				securities = {
					info = "info",
				},
			},
			eslint = {
				sourceName = "eslint",
				command = "./node_modules/.bin/eslint",
				rootPatterns = { ".git" },
				debounce = 100,
				args = {
					"--stdin",
					"--stdin-filename",
					"%filepath",
					"--format",
					"json",
				},
				parseJson = {
					errorsRoot = "[0].messages",
					line = "line",
					column = "column",
					endLine = "endLine",
					endColumn = "endColumn",
					message = "${message} [${ruleId}]",
					security = "severity",
				},
				securities = {
					[2] = "error",
					[1] = "warning",
				},
			},
		},
		filetypes = {
			["*"] = { "ligma" },
			["javascript"] = "eslint",
			["javascriptreact"] = "eslint",
			["typescript"] = "eslint",
			["typescriptreact"] = "eslint",
			["lua"] = "luacheck",
		},
	},
})

--
-- Bash
--
lspconfig.bashls.setup({})

--
-- Django
--

lspconfig.djlsp.setup({})

--
-- HTML
--
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.html.setup({
	capabilities = capabilities,
})

-- Styling (CSS/SCSS)
-- lspconfig.stylelint_lsp.setup({
--     cmd = { "stylelint-lsp", "--stdio" },
-- 	settings = {
-- 		stylelintplus = {
-- 			-- see available options in stylelint-lsp documentation
-- 		},
-- 	},
-- })

lspconfig.cssls.setup({
    capabilities = capabilities,
})

-- JSON
lspconfig.jsonls.setup({
	capabilities = capabilities,
})

--
-- HTMX
--

lspconfig.htmx.setup({})


--
-- Docker Compose
--
lspconfig.docker_compose_language_service.setup({})

--
-- Docker
--
lspconfig.dockerls.setup({
    settings = {
        docker = {
            languageserver = {
                formatter = {
                ignoreMultilineInstructions = true,
                },
            },
        }
    }
})

--
-- C/C++/Objective-C and Swift

lspconfig.sourcekit.setup({
    -- filetypes = { 
    --     -- "swift", 
    --     "c", 
    --     "cpp", 
    --     -- "objective-c", 
    --     -- "objective-cpp"
    -- },
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
    },
})

lspconfig.clangd.setup({})

--
-- SQL
--

lspconfig.sqls.setup({
  on_attach = function(client, bufnr)
    require("sqls").on_attach(client, bufnr) -- require sqls.nvim
  end,
  settings = {
    sqls = {
      connections = {
        {
          driver = "postgresql",
          -- DropSpot specific
          dataSourceName = "host=127.0.0.1 port=5432 user=dropspot password=dropspot dbname=dropspot sslmode=disable",
        },
      },
    },
  },
})
