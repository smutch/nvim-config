return {
    -- s({ trig = "col", name = "columns", descr = "Pandoc column divs" }, {
    --     t("::::::::: {.columns}"),
    --     t{"", "::::::: {.column width="}, i(1, "50"), t("%}"),
    --     t{"", "", ""}, i(0),
    --     t{"", "", ":::::::"},
    --     t{"", "::::::: {.column width="}, i(2, "50"), t("%}"),
    --     t{"", "", "", "", ":::::::"},
    --     t{"", ":::::::::"},
    -- })

    s({ trig = "col", name = "columns", descr = "Pandoc column divs" }, {
        t"::::::::: {.columns}",
        t{"", "::::::: {.column width="}, i(1, "50"), t"%}",
        t{"", "", ""}, i(0),
        t{"", "", ":::::::"},
        t{"", "::::::: {.column width="}, d(2, function(args)
            return sn(nil, {
                i(1, tostring(100-tonumber(args[1][1])))
            })
        end, {1}), t"%}",
        t{"", "", "", "", ":::::::"},
        t{"", ":::::::::"},
    })
}
