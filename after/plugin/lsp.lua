local lspconfig = require("lspconfig")

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local conform = require("conform")

cmp.setup({
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  }),
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
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(event)
    local bufnr = event.buf
    local opts = {buffer = event.buf}

    -- these will be buffer-local keybindings
    -- because they only work if you have an active language server

    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader><F2>", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>f", function()
        conform.format({ bufnr = bufnr })
    end, opts)
    vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)
  end
})

lspconfig.opts = {
	inlay_hints = {
		enabled = true,
	},
}

---
-- Replace these language servers
-- with the ones you have installed in your system
---
-- lspconfig.eslint.setup({
--   capabilities = capabilities,
-- })

-- Python

-- https://github.com/microsoft/pyright/blob/main/docs/configuration.md
lspconfig.pyright.setup({
  capabilities = capabilities,
  settings = {
    python = {
	  analysis = {
		reportWildcardImportFromLibrary = "none",
		reportUnknownMemberType = "none",
	  },
	},
  },
})

lspconfig.ruff.setup({
  capabilities = capabilities,
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

lspconfig.vtsls.setup({
  capabilities = capabilities,
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

lspconfig.rust_analyzer.setup({
  capabilities = capabilities,
})

--
-- Go
--

lspconfig.gopls.setup({
  capabilities = capabilities,
})

vim.filetype.add({ extension = { templ = "templ" } })

lspconfig.templ.setup({
  on_attach = function(client, bufnr)
    -- Do nothing for now 
  end,
})

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
            -- Don't use "typescript" or "typescript" as weird local babel configurations mess it up
			["lua"] = "luacheck",
		},
	},
})

--
-- Bash
--
lspconfig.bashls.setup({
  capabilities = capabilities,
})

--
-- Django
--

lspconfig.djlsp.setup({
  capabilities = capabilities,
})

--
-- HTML
--
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
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

lspconfig.htmx.setup({
    capabilities = capabilities,
})


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

lspconfig.clangd.setup({
  capabilities = capabilities,
})

--
-- SQL
--

lspconfig.sqls.setup({
  capabilities = capabilities,
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

--
-- Lua
--

lspconfig.lua_ls.setup({
  capabilities = capabilities,
})

