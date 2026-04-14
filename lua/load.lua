local M = {}

local misc = require("mini.misc")

M.later = function(f)
    misc.safely("later", f)
end
M.on_event = function(ev, f)
    misc.safely("event:" .. ev, f)
end

M.gh = function(repo)
    local prefix = "https://github.com/"
    if type(repo) == "string" then
        return prefix .. repo
    else
        local adjusted = {}
        for _, r in ipairs(repo) do
            table.insert(adjusted, prefix .. r)
        end
        return adjusted
    end
end

return M
