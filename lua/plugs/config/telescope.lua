local telescope = require 'telescope'
telescope.setup {
	pickers = {
		find_files = { theme = "dropdown" },
		git_files  = { theme = "dropdown" },
		old_files  = { theme = "dropdown" },
		buffers    = { theme = "dropdown" },
		marks      = { theme = "dropdown" },
		emoji      = { theme = "dropdown" },
		symbols    = { theme = "dropdown" },
	},
	extensions = { ["ui-select"] = { require("telescope.themes").get_dropdown() }
	}
}

local extensions = { "fzy_native", "emoji", "neoclip", "ui-select", "lazy_plugins", "undo" }
for _, extension in ipairs(extensions) do telescope.load_extension(extension) end

vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>',
	{ noremap = true, desc = "Telescope - files" })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope git_files<cr>',
	{ noremap = true, desc = "Telescope - git files" })
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>',
	{ noremap = true, desc = "Telescope - buffers" })
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope oldfiles<cr>',
	{ noremap = true, desc = "Telescope - history" })
vim.keymap.set('n', '<leader>f?', '<cmd>Telescope help_tags<cr>',
	{ noremap = true, desc = "Telescope - help tags" })
vim.keymap.set('n', '<leader>f:', '<cmd>Telescope commands<cr>',
	{ noremap = true, desc = "Telescope - commands" })
vim.keymap.set('n', '<leader>fm', '<cmd>Telescope marks<cr>', { noremap = true, desc = "Telescope - marks" })
vim.keymap.set('n', '<leader>fl', '<cmd>Telescope loclist<cr>',
	{ noremap = true, desc = "Telescope - loclist" })
vim.keymap.set('n', '<leader>fq', '<cmd>Telescope quickfix<cr>',
	{ noremap = true, desc = "Telescope - quickfix" })
vim.keymap.set('n', [[<leader>f"]], '<cmd>Telescope registers<cr>',
	{ noremap = true, desc = "Telescope - registers" })
vim.keymap.set('n', '<leader>fk', '<cmd>Telescope keymaps<cr>',
	{ noremap = true, desc = "Telescope - keymaps" })
vim.keymap.set('n', '<leader>ft', '<cmd>Telescope treesitter<cr>',
	{ noremap = true, desc = "Telescope - treesitter" })
vim.keymap.set('n', '<leader>fe', '<cmd>Telescope emoji<cr>', { noremap = true, desc = "Telescope - emoji" })
vim.keymap.set('n', '<leader>f<leader>', '<cmd>Telescope<cr>', { noremap = true, desc = "Telescope" })
vim.keymap.set('n', '<leader>fs', '<cmd>Telescope symbols<cr>',
	{ noremap = true, desc = "Telescope - symbols" })
vim.keymap.set('n', '<leader>fp', '<cmd>Telescope lazy_plugins<cr>',
	{ noremap = true, desc = "Telescope - plugins" })
vim.keymap.set('n', '<leader>fu', '<cmd>Telescope undo<cr>', { noremap = true, desc = "Telescope - undo" })
vim.keymap.set('n', 'z=',
	function() require 'telescope.builtin'.spell_suggest(require 'telescope.themes'.get_dropdown {}) end,
	{ noremap = true })

-- to fix gub introduced into neovim by vim patch
-- (https://github.com/nvim-telescope/telescope.nvim/issues/2027#issuecomment-1510001730)
local augroup = vim.api.nvim_create_augroup("Telescope", {})
vim.api.nvim_create_autocmd({ "WinLeave" }, {
	group = augroup,
	callback = function()
		if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
		end
	end
})

local function my_grep()
	local opts = {}

	if vim.bo.filetype == "oil" then
		opts = { search_dirs = { require "oil".get_current_dir() } }
	end

	require "telescope.builtin".live_grep(opts)
end

vim.keymap.set('n', '<leader>/', my_grep)
vim.api.nvim_create_user_command("MyGrep", my_grep, {})
