local gh = require("load").gh

vim.pack.add({{ src = gh("jake-stewart/multicursor.nvim"), branch = "1.0" }})

local mc = require("multicursor-nvim")
mc.setup()

local set = vim.keymap.set

-- Add or skip cursor above/below the main cursor.
set({ "n", "v" }, "g<up>", function()
    mc.lineAddCursor(-1)
end, { desc = "Add cursor above" })
set({ "n", "v" }, "g<down>", function()
    mc.lineAddCursor(1)
end, { desc = "Add cursor below" })
set({ "n", "v" }, "g<S-up>", function()
    mc.lineSkipCursor(-1)
end, { desc = "Skip cursor above" })
set({ "n", "v" }, "g<S-down>", function()
    mc.lineSkipCursor(1)
end, { desc = "Skip cursor below" })

-- Add or skip adding a new cursor by matching word/selection
set({ "n", "v" }, "<M-d>", function()
    mc.matchAddCursor(1)
end, { desc = "Add cursor by matching forward" })
set({ "n", "v" }, "gl", function()
    mc.matchAddCursor(1)
end, { desc = "Add cursor by matching forward" })
set({ "n", "v" }, "<M->>", function()
    mc.matchSkipCursor(1)
end, { desc = "Skip cursor by matching forward" })
set({ "n", "v" }, "gL", function()
    mc.matchSkipCursor(1)
end, { desc = "Skip cursor by matching forward" })
set({ "n", "v" }, "<M-S-d>", function()
    mc.matchAddCursor(-1)
end, { desc = "cdd cursor by matching backwards" })
set({ "n", "v" }, "gh", function()
    mc.matchAddCursor(-1)
end, { desc = "Add cursor by matching backwards" })
set({ "n", "v" }, "<M-<>", function()
    mc.matchSkipCursor(-1)
end, { desc = "Skip cursor by matching backwards" })
set({ "n", "v" }, "gH", function()
    mc.matchSkipCursor(-1)
end, { desc = "Skip cursor by matching backwards" })
set({ "n", "v" }, "<M-*>", function()
    mc.matchAllAddCursors()
end, { desc = "Add all cursors by matching" })
set({ "n", "v" }, "ga", function()
    mc.matchAllAddCursors()
end, { desc = "Add all cursors by matching" })

-- You can also add cursors with any motion you prefer:
-- set("n", "<right>", function()
--     mc.addCursor("w")
-- end)
-- set("n", "<leader><right>", function()
--     mc.skipCursor("w")
-- end)

-- Rotate the main cursor.
set({ "n", "v" }, "g<left>", mc.nextCursor, { desc = "Rotate main cursor left" })
set({ "n", "v" }, "g<right>", mc.prevCursor, { desc = "Rotate main cursor right" })

-- Delete the main cursor.
set({ "n", "v" }, "<leader>mx", mc.deleteCursor, { desc = "Delete main cursor" })

-- Add and remove cursors with control + left click.
set("n", "<c-leftmouse>", mc.handleMouse)

set({ "n", "v" }, "<leader>mq", function()
    if mc.cursorsEnabled() then
        -- Stop other cursors from moving.
        -- This allows you to reposition the main cursor.
        mc.disableCursors()
    else
        mc.addCursor()
    end
end, { desc = "Cancel multi cursor" })

-- -- clone every cursor and disable the originals
-- set({"n", "v"}, "<leader><c-q>", mc.duplicateCursors)

set("n", "<esc>", function()
    if not mc.cursorsEnabled() then
        mc.enableCursors()
    elseif mc.hasCursors() then
        mc.clearCursors()
    else
        -- Default <esc> handler.
    end
end)

-- Align cursor columns.
set("v", "<leader>ma", mc.alignCursors, { desc = "Align cursor columns" })

-- Split visual selections by regex.
-- set("v", "S", mc.splitCursors)

-- Append/insert for each line of visual selections.
set("v", "I", mc.insertVisual)
set("v", "A", mc.appendVisual)

-- match new cursors within visual selections by regex.
set("v", "<leader>m/", mc.matchCursors, { desc = "Match cursors by regex" })

-- -- Rotate visual selection contents.
-- set("v", "<leader>{",
--     function() mc.transposeCursors(-1) end)
-- set("v", "<leader>}",
--     function() mc.transposeCursors(1) end)

-- Customize how cursors look.
local hl = vim.api.nvim_set_hl
hl(0, "MultiCursorCursor", { reverse = true })
hl(0, "MultiCursorVisual", { link = "Visual" })
hl(0, "MultiCursorSign", { link = "SignColumn" })
hl(0, "MultiCursorDisabledCursor", { reverse = true })
hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
