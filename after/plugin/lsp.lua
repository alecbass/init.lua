local lsp = require('lsp-zero')
local lspconfig = require('lspconfig')

lsp.on_attach(function(client, bufnr)
    print("LSP working")
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp.default_keymaps({buffer = bufnr})
end)

---
-- Replace these language servers
-- with the ones you have installed in your system
---
lspconfig.rust_analyzer.setup{}
lspconfig.tsserver.setup({})
lspconfig.eslint.setup{}
-- Python
lspconfig.pylsp.setup{
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    ignore = {'W391'},
                    maxLineLength = 120
                },
                autopep8 = {
                    enabled = true
                },
                ruff = {
                    enabled = true,
                    lineLength = 120,
                }
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

