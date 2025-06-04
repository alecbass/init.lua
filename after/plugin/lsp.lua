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
vim.lsp.config("pyright", {
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
vim.lsp.enable("pyright")

vim.lsp.config("ruff", {
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
    }
  }
})
vim.lsp.enable("ruff")

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

vim.lsp.config("vtsls", {
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
vim.lsp.enable("vtsls")

--
-- Rust
--

vim.lsp.config("rust_analyzer", {
  capabilities = capabilities, -- Required for make import suggestions appear
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = true;
      }
    }
  }
})
vim.lsp.enable("rust_analyzer")

--
-- Go
--

vim.lsp.config("gopls", {
  capabilities = capabilities,
})
vim.lsp.enable("gopls")

vim.filetype.add({ extension = { templ = "templ" } })

vim.lsp.config("templ", {
  on_attach = function(client, bufnr)
    -- Do nothing for now 
  end,
})
vim.lsp.enable("templ")

--
-- Diagnostic Language Server
--
local eslint = require("diagnosticls-configs.linters.eslint")
local prettier = require("diagnosticls-configs.formatters.prettier")
local black = require("diagnosticls-configs.formatters.black")
local luacheck = require("diagnosticls-configs.linters.luacheck")

vim.lsp.config("diagnosticls", {
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
vim.lsp.enable("diagnosticls")

--
-- Bash
--
vim.lsp.config("bashls", {
  capabilities = capabilities,
})
vim.lsp.enable("bashls")

--
-- Django
--

vim.lsp.config("djlsp", {
  capabilities = capabilities,
})
vim.lsp.enable("djlsp")

--
-- HTML
--
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config("html", {
	capabilities = capabilities,
    settings = {
      filetypes = { "html", "templ", "aspnetcorerazor" },
    },
    filetypes = { "html", "templ", "aspnetcorerazor" },
})
vim.lsp.enable("html")

-- Styling (CSS/SCSS)

vim.lsp.config("cssls", {
    capabilities = capabilities,
})
vim.lsp.enable("cssls")

--
-- HTMX
--

vim.lsp.config("htmx", {
    capabilities = capabilities,
})
vim.lsp.enable("htmx")

-- JSON
vim.lsp.config("jsonls", {
	capabilities = capabilities,
})
vim.lsp.enable("jsonls")

--
-- Docker Compose
--
vim.lsp.config("docker_compose_language_service", {})
vim.lsp.enable("docker_compose_language_service")

--
-- Docker
--
vim.lsp.config("dockerls", {
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
vim.lsp.enable("dockerls")

--
-- C/C++/Objective-C and Swift

vim.lsp.config("sourcekit", {
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
vim.lsp.enable("sourcekit")

vim.lsp.config("clangd", {
  capabilities = capabilities,
})
vim.lsp.enable("clangd")

--
-- SQL
--

-- lspconfig.sqls.setup({
--   capabilities = capabilities,
--   on_attach = function(client, bufnr)
--     require("sqls").on_attach(client, bufnr) -- require sqls.nvim
--   end,
--   settings = {
--     sqls = {
--       connections = {
--         {
--           driver = "postgresql",
--           -- DropSpot specific
--           dataSourceName = "host=127.0.0.1 port=5432 user=dropspot password=dropspot dbname=dropspot sslmode=disable",
--         },
--       },
--     },
--   },
-- })

vim.lsp.config("postgres_lsp", {
  capabilities = capabilities,
})
vim.lsp.enable("postgres_lsp")

--
-- Lua
--

vim.lsp.config("lua_ls", {
  capabilities = capabilities,
})
vim.lsp.enable("lua_ls")

--
-- Cypher (neo4j)
--

vim.lsp.config("cypher_ls", {})
vim.lsp.enable("cypher_ls")

--
-- Dotnet (C#)
--

-- C# and Razor
vim.lsp.config("roslyn_ls", {
    -- cmd = cmd,
    -- handlers = require("rzls.roslyn_handlers"),
    --
    settings = {
        ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
        },
        ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
        },
    },
})
vim.lsp.enable("roslyn_ls")


-- autocmd BufNewFile,BufRead *.cshtml set filetype=html.cshtml.razor
-- autocmd BufNewFile,BufRead *.razor set filetype=html.cshtml.razor

-- vim.api.nvim_create_autocmd("LspAttach", {
--   desc = "LSP actions",
--   callback = function(event)
--     local bufnr = event.buf
--     local opts = {buffer = event.buf}
--
--     -- these will be buffer-local keybindings
--     -- because they only work if you have an active language server
--
--     vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
--     vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
--     vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
--     vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
--     vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
--     vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
--     vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
--     vim.keymap.set("n", "<leader><F2>", vim.lsp.buf.rename, opts)
--     vim.keymap.set("n", "<leader>f", function()
--         conform.format({ bufnr = bufnr })
--     end, opts)
--     vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)
--   end
-- })
