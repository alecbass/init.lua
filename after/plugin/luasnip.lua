local luasnip = require("luasnip")
-- Shorthands
local s = luasnip.snippet
local sn = luasnip.snippet_node
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node
local c = luasnip.choice_node
local d = luasnip.dynamic_node
local r = luasnip.restore_node

local fmt = require("luasnip.extras.fmt").fmt

local typescript_snippets = require("snippets.typescript")
local go_snippets = require("snippets.go")

luasnip.setup({})

luasnip.filetype_extend("all", { "_" })
luasnip.filetype_extend("lua", { "c", "typescript" })
luasnip.filetype_extend("lua", { "c", "typescript" })

luasnip.add_snippets("all", go_snippets, { key = "all" })
luasnip.add_snippets("typescript", typescript_snippets, { key = "typescript" })
luasnip.add_snippets("go", go_snippets, { key = "go" })

require("luasnip.loaders.from_vscode").lazy_load()

require("luasnip.loaders.from_lua").lazy_load({ include = { "all", "c", "lua", "typescript" } })
require("luasnip.loaders.from_lua").lazy_load({ include = { "cpp" } })

