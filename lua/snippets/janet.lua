local ls = require("luasnip")
local s = ls.snippet
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

function filename()
	return f(function(_args, snip) return snip.snippet.env.TM_FILENAME end)
end

return {
	s("format", fmt([[
	(import spork/fmt)
	(fmt/format-file "{}")
	]], { filename() }))
}
