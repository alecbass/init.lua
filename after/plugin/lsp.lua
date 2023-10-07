local lsp = require('lsp-zero')
local lspconfig = require('lspconfig')

local cmp = require("cmp")
local cmp_action = require('lsp-zero').cmp_action()

local cmp_select = {behavior = cmp.SelectBehavior.Select}
cmp.setup({
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<Enter>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<Tab>'] = nil,
        ['<S-Tab>'] = nil,
    })
})


lsp.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp.default_keymaps({buffer = bufnr})

    local opts = {buffer = bufnr, remap = false}

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format() { async = true } end, opts)
    vim.keymap.set("n", "<leader><F2>", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
end)

---
-- Replace these language servers
-- with the ones you have installed in your system
---
lspconfig.rust_analyzer.setup{}
lspconfig.eslint.setup{}
-- Python

-- https://github.com/microsoft/pyright/blob/main/docs/configuration.md
lspconfig.pyright.setup {
    settings = {
        python = {
            analysis = {
                reportWildcardImportFromLibrary = "none",
                reportUnknownMemberType = "none",
            }
        }
    }
}
lspconfig.ruff_lsp.setup{
  init_options = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      args = {},
    }
  }
}

lsp.format_on_save({
  format_opts = {
    async = false,
    timeout_ms = 10000,
  },
  servers = {
    ['tsserver'] = {'javascript', 'typescript'},
    ['rust_analyzer'] = {'rust'},
  }
})

local rust_tools = require('rust-tools')

rust_tools.setup({
  server = {
    on_attach = function(client, bufnr)
      vim.keymap.set('n', '<leader>ca', rust_tools.hover_actions.hover_actions, {buffer = bufnr})
    end
  }
})


-- Diagnostic Language Server
lspconfig.diagnosticls.setup {
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
                    info = "info"
                }
            }
        },
        filetypes = {
            ["*"] = { "ligma" }
        }
    }
}

-- Bash
require'lspconfig'.bashls.setup{}

