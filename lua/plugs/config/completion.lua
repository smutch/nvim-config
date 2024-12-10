local blink = require("blink.cmp")

local has_words_before = function()
	if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
		return false
	end
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end


blink.setup({
	keymap = {
		preset = "enter",
		["<Tab>"] = {
			"select_next",
			function(cmp)
				if has_words_before() then
					cmp.accept()
				end
			end,
			"fallback",
		},
		["<S-Tab>"] = { "select_prev", "fallback" },
	},
	completion = {
		list = {
			selection = "auto_insert",
		},
		accept = {
			auto_brackets = { enabled = true },
		}, -- WARNING: experimental
		signature = {
			enabled = true, -- WARNING: experimental
		},
	},
	sources = {
		completion = {
			enabled_providers = { "lsp", "path", "luasnip", "buffer", "lazydev", "otter" },
		},
		providers = {
			-- create provider
			otter = {
				name = "otter",
				module = "blink.compat.source",
			},
			lsp = { fallback_for = { "lazydev" } },
			lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
		},
	},
	snippets = {
		expand = function(snippet)
			require("luasnip").lsp_expand(snippet)
		end,
		active = function(filter)
			if filter and filter.direction then
				return require("luasnip").jumpable(filter.direction)
			end
			return require("luasnip").in_snippet()
		end,
		jump = function(direction)
			require("luasnip").jump(direction)
		end,
	},
	draw = {
		padding = { 1, 0 },
		columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
		components = {
			kind_icon = { width = { fill = true } },
		},
	},
})
