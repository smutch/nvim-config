local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

return {
    s("es", t("<!-- end_slide -->")),
    s("jtm", t("<!-- jump_to_middle -->")),
    s("nl", t("<!-- new_line -->")),
}
