-- Lua file
local function on_attach(client)
  print('Attached to ' .. client.name)
end

local dlsconfig = require 'diagnosticls-configs'

dlsconfig.init {
  -- Your custom attach function
  on_attach = on_attach,
}

-- Lua file
local eslint = require 'diagnosticls-configs.linters.eslint'
local standard = require 'diagnosticls-configs.linters.standard'
local prettier = require 'diagnosticls-configs.formatters.prettier'
local prettier_standard = require 'diagnosticls-configs.formatters.prettier_standard'
dlsconfig.setup {
  ['javascript'] = {
    linter = eslint,
    formatter = prettier
  },
  ['javascriptreact'] = {
    -- Add multiple linters
    linter = eslint,
    -- Add multiple formatters
    formatter = prettier
  },
  ['typescript'] = {
      linter = eslint,
      formatter = prettier
  },
  ['typescriptreact'] = {
      linter = eslint,
      formatter = prettier
  },
}
