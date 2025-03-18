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

luasnip.setup({})

-- Gets the current file name, without its extension
function get_file_name()
    -- The path to this file from the nvim config root
    local path = string.gsub(vim.api.nvim_buf_get_name(0), vim.loop.cwd(), '')

    local file_name = ""
    -- Iterate over every directory until we get to the last element: the file name
    -- i.e. /after/plugin/luasnip.lua -> { "after", "plugin", "luasnip.lua" }
    for token, _ in string.gmatch(path, "[^/%s]+") do
       file_name = token
    end

    -- i.e. luasnip.
    local name = string.gmatch(file_name, "[^%s$].+[\\.]")

    local name_without_extension = ""
    for name_section in name do
        -- Cut off the trailing dot
        local length = string.len(name_section)
        name_without_extension = string.sub(name_section, 1, length - 1)

        break
    end

    return name_without_extension
end

-- Transforms "cool-component" into "CoolComponent"
function create_class_name(file_name)
    -- Capitalised class name
    local class_name = ""

    -- Used to know if we reach a '-' OR at the first character, which should be capitalised
    local should_capitalise_next_char = true

    -- Iterate character-by-character, ignoring dashes and capitalising the next character when we see one
    for index = 1, #file_name do
        local char = file_name:sub(index, index)
        local should_skip = char == "-"

        if should_capitalise_next_char then
            char = char:upper()
            should_capitalise_next_char = false
        end

        if should_skip == false then
            class_name = class_name .. char
        else
            -- No continue statement in lua :(
            should_capitalise_next_char = true
        end
    end

    return class_name
end

function insert_class_name(args, snip, old_state, user_args)
  -- Transform the file name into both a class name, and a tag name
  -- cool-component.ts -> CoolComponent
  local file_name = get_file_name()
  local class_name = create_class_name(file_name) .. "Element"

  return sn(nil, t(class_name))
end

function insert_tag_name(args, snip, old_state, user_args)
  -- Just use the file name
  local file_name = get_file_name()

  return sn(nil, t(file_name))
end

luasnip.add_snippets("typescript", {
	s("web",
        -- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
        -- i(1, "cond"), t(" ? "), i(2, "then"), t(" : "), i(3, "else")
        fmt(
            [[
              export class {} extends HTMLElement {{
                static observedAttributes = [];

                connectedCallback() {{}}

                disconnectedCallback() {{}}

                attributeChangedCallback(name: string, oldValue: string | null, newValue: string | null) {{}}
              }}

              customElements.define("{}", {});

              declare global {{
                interface HTMLElementTagNameMap {{
                  "{}": {};
                }}
              }}

            ]]
        , {
          -- It would be nice to use named keys here, but we get a weird position_so_far not found error when re-using
          -- the same formatting key
          d(1, insert_class_name, {}, {}),
          d(2, insert_tag_name, {}, {}),
          d(3, insert_class_name, {}, {}),
          d(4, insert_tag_name, {}, {}),
          d(5, insert_class_name, {}, {}),
        })
    ),
	s("lit",
        -- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
        -- i(1, "cond"), t(" ? "), i(2, "then"), t(" : "), i(3, "else")
        fmt(
            [[
              import {{ html, css, LitElement }} from "lit";
              import {{ customElement, property }} from "lit/decorators.js";

              @customElement("{}")
              export class {} extends LitElement {{
                static styles = css``;

                @property()
                value = "placeholder";

                render() {{
                  return html`
                  `;
                }}
              }}

              declare global {{
                interface HTMLElementTagNameMap {{
                  "{}": {};
                }}
              }}

            ]]
        , {
          -- It would be nice to use named keys here, but we get a weird position_so_far not found error when re-using
          -- the same formatting key
          d(1, insert_tag_name, {}, {}),
          d(2, insert_class_name, {}, {}),
          d(3, insert_tag_name, {}, {}),
          d(4, insert_class_name, {}, {}),
        })
    ),
    s("class", {
		-- Choice: Switch between two different Nodes, first parameter is its position, second a list of nodes.
		c(1, {
			t("public "),
			t("private "),
		}),
		t("class "),
		i(2),
		t(" "),
		c(3, {
			t("{"),
			-- sn: Nested Snippet. Instead of a trigger, it has a position, just like insertNodes. !!! These don't expect a 0-node!!!!
			-- Inside Choices, Nodes don't need a position as the choice node is the one being jumped to.
			sn(nil, {
				t("extends "),
				-- restoreNode: stores and restores nodes.
				-- pass position, store-key and nodes.
				r(1, "other_class", i(1)),
				t(" {"),
			}),
			sn(nil, {
				t("implements "),
				-- no need to define the nodes for a given key a second time.
				r(1, "other_class"),
				t(" {"),
			}),
		}),
		t({ "", "\t" }),
		i(0),
		t({ "", "}" }),
	}),
    s(
		"fmt1",
		fmt("To {title} {} {}.", {
			i(2, "Name"),
			i(3, "Surname"),
			title = c(1, { t("Mr."), t("Ms.") }),
		})
	),
}, {
	key = "lua",
})

luasnip.filetype_extend("all", { "_" })
luasnip.filetype_extend("lua", { "c", "typescript" })

require("luasnip.loaders.from_vscode").lazy_load()

require("luasnip.loaders.from_lua").lazy_load({ include = { "all", "c", "lua", "typescript" } })
require("luasnip.loaders.from_lua").lazy_load({ include = { "cpp" } })

