local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

return {
	s("format", {
		t({ "(do ", "  (import spork/fmt)", "  (fmt/format-file \"day6.janet\"))" })
	})
}
