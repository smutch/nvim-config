local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

return {
    s("list", t({ "@_list:", "    just --list" })),
}
