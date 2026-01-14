local llama_server_endpoint = "http://127.0.0.1:8080/infill" -- Default is http://127.0.0.1:8012/infill
local status = os.execute(string.format("curl --silent --fail-with-body %s", llama_server_endpoint))
local is_failure = status > 0

local supermaven = require("supermaven-nvim")

-- Run Supermaven if there's no local LLM
if is_failure then
	-- Thank you Nick for the setup :)
	supermaven.setup({
		ignore_filetypes = {},
		disable_inline_completion = false,
		disable_keymaps = false,
	})
end
