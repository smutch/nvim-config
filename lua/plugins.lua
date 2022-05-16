-- begin by ensure packer is actually installed!
-- local execute = vim.api.nvim_command
local fn = vim.fn

local install_path =  fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    -- fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    PACKER_BOOTSTRAP = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
end
require'packer'.init({ max_jobs = 50 })


-- configure plugins
return require'packer'.startup(function(use, use_rocks)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Utility stuff used by lots of plugins
    use 'nvim-lua/plenary.nvim'

    -- lsp and completion {{{
    use {
        'neovim/nvim-lsp',
        requires = {
            'neovim/nvim-lspconfig', 'williamboman/nvim-lsp-installer', {
                'ray-x/lsp_signature.nvim',
                config = function()
                    require'lsp_signature'.setup { fix_pos = true, hint_enable = false, hint_prefix = " " }
                    vim.cmd([[hi link LspSignatureActiveParameter SpellBad]])
                end,
            }, 'jose-elias-alvarez/null-ls.nvim', {
                'hrsh7th/nvim-cmp',
                requires = {
                    'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer',
                    { 'Saecki/crates.nvim', config = function() require('crates').setup() end }, 'hrsh7th/cmp-path',
                    'hrsh7th/cmp-nvim-lua', -- {'andersevenrud/compe-tmux', branch='cmp'},
                    'kdheepak/cmp-latex-symbols', 'f3fora/cmp-spell', 'hrsh7th/cmp-calc', 'ray-x/cmp-treesitter',
                    'hrsh7th/cmp-emoji', 'hrsh7th/cmp-omni', 'hrsh7th/cmp-cmdline', {
                        'L3MON4D3/LuaSnip',
                        config = function()
                            local h = require 'helpers'
                            require 'snippets'

                            function _G.luasnip_map_forward()
                                local luasnip = require 'luasnip'
                                if luasnip.expand_or_jumpable() then
                                    luasnip.expand_or_jump()
                                    return true
                                end
                                return false
                            end

                            function _G.luasnip_map_backward()
                                local luasnip = require 'luasnip'
                                if luasnip.jumpable(-1) then
                                    luasnip.jump(-1)
                                    return true
                                end
                                return false
                            end

                            h.noremap('i', '<C-l>', '<cmd>call v:lua.luasnip_map_forward()<cr>')
                            h.noremap('s', '<C-l>', '<cmd>call v:lua.luasnip_map_forward()<cr>')
                            h.noremap('i', '<C-y>', '<cmd>call v:lua.luasnip_map_backward()<cr>')
                            h.noremap('s', '<C-y>', '<cmd>call v:lua.luasnip_map_backward()<cr>')
                        end
                    }, 'saadparwaiz1/cmp_luasnip', 'rafamadriz/friendly-snippets', 'onsails/lspkind-nvim',
                    { 'windwp/nvim-autopairs', config = function() require'nvim-autopairs'.setup {} end },
                    'nvim-lua/lsp_extensions.nvim', 'kosayoda/nvim-lightbulb',
                    'lukas-reineke/cmp-under-comparator'
                },
                config = function()
                    vim.o.completeopt = 'menu,menuone,noselect'
                    local cmp = require 'cmp'

                    local has_words_before = function()
                        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                        return col ~= 0 and
                                   vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") ==
                                   nil
                    end

                    cmp.setup({
                        snippet = { expand = function(args)
                            require('luasnip').lsp_expand(args.body)
                        end },
                        mapping = {
                            ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
                            ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
                            ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
                            ['<C-e>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
                            ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),

                            ["<Tab>"] = cmp.mapping(function(fallback)
                                local luasnip = require 'luasnip'
                                if cmp.visible() then
                                    cmp.select_next_item()
                                elseif luasnip.expandable() then
                                    luasnip.expand()
                                elseif has_words_before() then
                                    cmp.complete()
                                else
                                    fallback()
                                end
                            end, { "i", "s" }),

                            ["<S-Tab>"] = cmp.mapping(function(fallback)
                                if cmp.visible() then
                                    cmp.select_prev_item()
                                else
                                    fallback()
                                end
                            end, { "i", "s" })
                        },
                        sources = cmp.config.sources({
                            { name = 'calc' }, { name = 'path' }, { name = 'nvim_lsp' }, { name = 'luasnip' },
                            { name = 'treesitter' }, { name = 'emoji' }, { name = 'buffer', keyword_length = 5 }
                        }),
                        formatting = { format = require'lspkind'.cmp_format({ with_text = true, maxwidth = 50 }) },
                        experimental = { native_menu = false, ghost_text = true },
                        sorting = {
                            comparators = {
                                cmp.config.compare.offset, cmp.config.compare.exact, cmp.config.compare.score,
                                require"cmp-under-comparator".under, cmp.config.compare.kind,
                                cmp.config.compare.sort_text, cmp.config.compare.length, cmp.config.compare.order
                            }
                        }
                    })

                    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
                    cmp.setup.cmdline('/', { sources = { { name = 'buffer' } } })

                    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
                    cmp.setup.cmdline(':', {
                        sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } })
                        -- completion = {
                        --     -- Use <tab> or <c-space> to request completion
                        --     autocomplete = false
                        -- },
                    })

                    local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
                    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '{' } }))

                    vim.cmd(
                        [[autocmd FileType lua lua require'cmp'.setup.buffer {sources = { { name = 'nvim_lua' } } }]])
                    vim.cmd([[autocmd FileType toml lua require'cmp'.setup.buffer {sources = { { name = 'crates' } } }]])
                    vim.cmd(
                        [[autocmd FileType tex lua require'cmp'.setup.buffer {sources = { { name = 'omni' } }, { name = 'latex_symbols'} }]])

                    vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
                    vim.fn.sign_define('LightBulbSign', { text = "ﯧ", texthl = "", linehl = "", numhl = "" })

                    vim.cmd(
                        [[autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs :lua require'lsp_extensions'.inlay_hints{ prefix = ' 﫢 ', highlight = "NonText", only_current_line = true, enabled = {"TypeHint", "ChainingHint", "ParameterHint"}}]])
                end
            }
        },
        config = function() require 'lsp' end
    }

    use { 'folke/lsp-trouble.nvim', config = function() require("trouble").setup {} end }

    use {
        'github/copilot.vim',
        opt = true,
        setup = function()
            vim.api.nvim_set_keymap('i', [[<C-j>]], [[copilot#Accept("<CR>")]],
                                    { silent = true, script = true, expr = true })
            vim.g.copilot_no_tab_map = true
        end
    }

    -- The rockspec for this is currently broken. Need to wait for a fix.
    -- use_rocks {'luaformatter', server = 'https://luarocks.org/dev'}

    -- }}}

    -- editing {{{
    use 'tpope/vim-rsi'
    use {
        'ggandor/lightspeed.nvim',
        config = function()
            -- These dummy mappings prevent lightspeed from implementing multi-line f/F/t/F
            -- jumps and breaking ; and ,
            vim.api.nvim_set_keymap('n', 'f', 'f', {})
            vim.api.nvim_set_keymap('n', 'F', 'F', {})
            vim.api.nvim_set_keymap('n', 't', 't', {})
            vim.api.nvim_set_keymap('n', 'T', 'T', {})
            vim.api.nvim_set_keymap('n', ';', ';', {})
            vim.api.nvim_set_keymap('n', ',', ',', {})
        end
    }

    use 'tpope/vim-repeat'
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup { mappings = { extended = true }, ignore = '^$' }
            vim.api.nvim_set_keymap('n', '<leader><leader>', 'gcc', {})
            vim.api.nvim_set_keymap('v', '<leader><leader>', 'gc', {})

            local U = require("Comment.utils")
            local A = require("Comment.api")

            function _G.___gpc(vmode)
                local range = U.get_region(vmode)
                -- print(vim.inspect(range))
                local lines = U.get_lines(range)
                -- print(vim.inspect(lines))

                -- Copying the block
                local srow = range.erow
                vim.api.nvim_buf_set_lines(0, srow, srow, false, lines)

                -- Doing the comment
                A.comment_linewise_op(vmode)

                -- Move the cursor
                local erow = srow + 1
                local line = U.get_lines({ srow = srow, erow = erow })
                local _, col = U.grab_indent(line[1])
                vim.api.nvim_win_set_cursor(0, { erow, col })
            end

            vim.api.nvim_set_keymap('v', 'gpc', '<esc><cmd>call v:lua.___gpc("V")<cr>', {noremap = true})
            vim.api.nvim_set_keymap('n', 'gpc', '<esc><cmd>call v:lua.___gpc()<cr>', {noremap = true})
        end
    }
    use {
        'junegunn/vim-easy-align',
        opt = true,
        event = 'InsertEnter',
        config = function()
            vim.api.nvim_set_keymap('v', '<Enter>', '<Plug>(EasyAlign)', {})
            vim.api.nvim_set_keymap('n', 'gA', '<Plug>(EasyAlign)', {})
        end
    }
    use 'michaeljsmith/vim-indent-object'
    use {
        'tpope/vim-surround',
        config = function()
            -- Extra surround mappings for particular filetypes

            -- Markdown
            vim.cmd([[autocmd FileType markdown let b:surround_109 = "\\\\(\r\\\\)" "math]])
            vim.cmd([[autocmd FileType markdown let b:surround_115 = "~~\r~~" "strikeout]])
            vim.cmd([[autocmd FileType markdown let b:surround_98 = "**\r**" "bold]])
            vim.cmd([[autocmd FileType markdown let b:surround_105 = "*\r*" "italics]])
        end
    }
    use { 'jeffkreeftmeijer/vim-numbertoggle', opt = true }
    use { 'chrisbra/unicode.vim', opt = true }
    use 'wellle/targets.vim'
    use {
        'edluffy/specs.nvim',
        config = function()
            require('specs').setup {
                popup = { inc_ms = 10, width = 50, winhl = "DiffText", resizer = require('specs').slide_resizer },
                ignore_filetypes = { "rust" }
            }
        end
    }
    use { 'editorconfig/editorconfig-vim', config = function() vim.g.EditorConfig_exclude_patterns = {'fugitive://.*'} end }
    -- }}}

    -- treesitter {{{
    use {
        'nvim-treesitter/nvim-treesitter',
        requires = 'nvim-treesitter/nvim-treesitter-textobjects',
        run = ':TSUpdate',
        config = function()
            require'nvim-treesitter.configs'.setup {
                highlight = {
                    enable = true, -- false will disable the whole extension
                    -- disable = { "c", "rust" },  -- list of language that will be disabled
                    custom_captures = { ["variable"] = "Normal" },
                    additional_vim_regex_highlighting = false
                },
                incremental_selection = { enable = false },
                refactor = {
                    highlight_definitions = { enable = true },
                    highlight_current_scope = { enable = true },
                    smart_rename = { enable = true, keymaps = { smart_rename = "gR" } }
                },
                textobjects = {
                    select = {
                        enable = true,

                        -- Automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,

                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["aP"] = "@parameter.outer",
                            ["iP"] = "@parameter.inner",
                            ["aC"] = "@comment.outer",
                            ["aB"] = "@block.outer",
                            ["iB"] = "@block.inner"

                            -- -- Or you can define your own textobjects like this
                            -- ["iF"] = {
                            --     python = "(function_definition) @function",
                            --     cpp = "(function_definition) @function",
                            --     c = "(function_definition) @function",
                            --     java = "(method_declaration) @function",
                            -- },
                        }
                    },
                    swap = {
                        enable = true,
                        swap_next = { ["<leader>a"] = "@parameter.inner" },
                        swap_previous = { ["<leader>A"] = "@parameter.inner" }
                    },
                    lsp_interop = {
                        enable = true,
                        border = 'none',
                        peek_definition_code = { ["<leader>df"] = "@function.outer", ["<leader>dF"] = "@class.outer" }
                    }
                }
            }
            local ft_to_parser = require('nvim-treesitter.parsers').filetype_to_parsername
            ft_to_parser.astro = "tsx"
            -- if vim.loop.os_uname().sysname == "Darwin" then
            --     require'nvim-treesitter.install'.compilers = { "gcc-11" }
            -- end
            -- require("nvim-treesitter.parsers").get_parser_configs().just = {
            --     install_info = {
            --         url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
            --         files = { "src/parser.c", "src/scanner.cc" },
            --         branch = "main"
            --     },
            --     maintainers = { "@IndianBoy42" }
            -- }
        end
    }
    use { 'nvim-treesitter/playground', opt = true }
    use {
        'tpope/vim-dispatch',
        config = function()
            vim.g.dispatch_compilers = { python = 'python %' }

            -- remove iterm from the list of handlers (don't like it removing focus when run)
            vim.g.dispatch_handlers = { 'tmux', 'screen', 'windows', 'x11', 'headless' }
        end
    }
    -- }}}

    -- utils {{{
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-eunuch'
    use {
        'rmagatti/auto-session',
        config = function()
            require('auto-session').setup {
                post_restore_cmds = {"stopinsert"}
            }
        end
    }
    use 'chrisbra/vim-diff-enhanced'
    use {
        'moll/vim-bbye',
        config = function() vim.api.nvim_set_keymap('n', 'Q', ':Bdelete<CR>', { noremap = true, silent = true }) end
    }

    use {
      'nvim-neo-tree/neo-tree.nvim',
      branch = "v2.x",
      requires = { "MunifTanjim/nui.nvim", "s1n7ax/nvim-window-picker" },
      config = function()
          local h = require 'helpers'
          vim.g.neo_tree_remove_legacy_commands = true

          require("neo-tree").setup({
              event_handlers = {
                  {
                      event = "file_open_requested",
                      handler = function(args)
                          local state = args.state
                          local path = args.path
                          local open_cmd = args.open_cmd or "edit"

                          if not state.window.position == "current" then

                              -- use last window if possible
                              local suitable_window_found = false
                              local nt = require("neo-tree")
                              if nt.config.open_files_in_last_window then
                                  local prior_window = nt.get_prior_window()
                                  if prior_window > 0 then
                                      local success = pcall(vim.api.nvim_set_current_win, prior_window)
                                      if success then
                                          suitable_window_found = true
                                      end
                                  end
                              end

                              -- find a suitable window to open the file in
                              if not suitable_window_found then
                                  if state.window.position == "right" then
                                      vim.cmd("wincmd t")
                                  else
                                      vim.cmd("wincmd w")
                                  end
                              end
                              local attempts = 0
                              while attempts < 4 and vim.bo.filetype == "neo-tree" do
                                  attempts = attempts + 1
                                  vim.cmd("wincmd w")
                              end
                              if vim.bo.filetype == "neo-tree" then
                                  -- Neo-tree must be the only window, restore it's status as a sidebar
                                  local winid = vim.api.nvim_get_current_win()
                                  local width = require("neo-tree.utils").get_value(state, "window.width", 40)
                                  vim.cmd("vsplit " .. path)
                                  vim.api.nvim_win_set_width(winid, width)
                              else
                                  vim.cmd(open_cmd .. " " .. path)
                              end

                          else
                              vim.cmd(open_cmd .. " " .. path)
                          end

                          -- If you don't return this, it will proceed to open the file using built-in logic.
                          return { handled = true }
                      end
                  },
              },
              filesystem = {
                  window = {
                      mappings = {
                          ["-"] = "navigate_up",
                      }
                  }
              }
          })

          h.noremap('n', '<leader>F', '<cmd>Neotree toggle<CR>')
          h.noremap('n', '-', '<cmd>Neotree focus current reveal_force_cwd<CR>')
      end
    }

    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-telescope/telescope-fzy-native.nvim', run = 'make -C deps/fzy-lua-native' },
            'xiyaowong/telescope-emoji.nvim', 'nvim-telescope/telescope-packer.nvim', {
                "AckslD/nvim-neoclip.lua",
                config = function()
                    require('neoclip').setup()
                    vim.api.nvim_set_keymap('n', '<leader>v', '<cmd>Telescope neoclip<cr>', { noremap = true })
                end
            }, 'nvim-telescope/telescope-symbols.nvim'
        },
        config = function()
            local h = require 'helpers'
            local telescope = require 'telescope'
            telescope.setup { pickers = { find_files = { theme = "dropdown" } } }

            local extensions = { "fzy_native", "packer", "emoji", "neoclip" }
            for _, extension in ipairs(extensions) do telescope.load_extension(extension) end

            h.noremap('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
            h.noremap('n', '<leader>fg', '<cmd>Telescope git_files<cr>')
            h.noremap('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
            h.noremap('n', '<leader>fh', '<cmd>Telescope oldfiles<cr>')
            h.noremap('n', '<leader>f?', '<cmd>Telescope help_tags<cr>')
            h.noremap('n', '<leader>f:', '<cmd>Telescope commands<cr>')
            h.noremap('n', '<leader>fm', '<cmd>Telescope marks<cr>')
            h.noremap('n', '<leader>fl', '<cmd>Telescope loclist<cr>')
            h.noremap('n', '<leader>fq', '<cmd>Telescope quickfix<cr>')
            h.noremap('n', [[<leader>f"]], '<cmd>Telescope registers<cr>')
            h.noremap('n', '<leader>fk', '<cmd>Telescope keymaps<cr>')
            h.noremap('n', '<leader>ft', '<cmd>Telescope treesitter<cr>')
            h.noremap('n', '<leader>fe', '<cmd>Telescope emoji<cr>')
            h.noremap('n', '<leader>fp', '<cmd>Telescope packer<cr>')
            h.noremap('n', '<leader>f<leader>', '<cmd>Telescope<cr>')
            h.noremap('n', '<leader>fs', '<cmd>Telescope symbols<cr>')
        end
    }

    use { 'folke/todo-comments.nvim', config = function() require("todo-comments").setup {} end }

    use { 'norcalli/nvim-colorizer.lua', opt = true, config = function() require'colorizer'.setup() end }
    use {
        'majutsushi/tagbar',
        config = function() vim.api.nvim_set_keymap('n', '<leader>T', ':TagbarToggle<CR>', {}) end,
        opt = true
    }
    use 'christoomey/vim-tmux-navigator'
    use { 'vim-test/vim-test', opt = true }
    -- use 'rcarriga/vim-ultest', { 'do': ':UpdateRemoteuseins', 'for': 'python' }

    use { 'rcarriga/nvim-notify', config = function() vim.notify = require 'notify' end }

    use {
        'dccsillag/magma-nvim',
        cmd = { 'MagmaInit' },
        run = ':UpdateRemotePlugins',
        ft = 'python',
        config = function()
            local h = require 'helpers'
            h.noremap('n', '<LocalLeader>r', 'nvim_exec("MagmaEvaluateOperator", v:true)',
                      { silent = true, expr = true })
            h.noremap('n', '<LocalLeader>rr', ':MagmaEvaluateLine<CR>', { silent = true })
            h.noremap('x', '<LocalLeader>r', ':<c-u>MagmaEvaluateVisual<CR>', { silent = true })
            h.noremap('n', '<LocalLeader>rc', ':MagmaReevaluateCell<CR>', { silent = true })
            h.noremap('n', '<LocalLeader>rd', ':MagmaDelete<CR>', { silent = true })
            h.noremap('n', '<LocalLeader>ro', ':MagmaShowOutput<CR>', { silent = true })

            vim.g.magma_automatically_open_output = false
        end
    }

    -- git
    use {
        'tpope/vim-fugitive',
        requires = { 'tpope/vim-git', 'junegunn/gv.vim' },
        config = function()
            vim.api.nvim_set_keymap('n', 'git', ':Git', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>gs', ':Git<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>ga', ':Git commit -a<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>gd', ':Git diff<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>gP', ':Git pull<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>gp', ':Git push<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>g/', ':Git grep<CR>', { noremap = true })
        end
    }
    use { 'lewis6991/gitsigns.nvim', config = function() require('gitsigns').setup() end }
    use { 'f-person/git-blame.nvim', config = function() vim.g.gitblame_enabled = 0 end }

    -- linting
    use { 'neomake/neomake', opt = true }

    -- docstrings
    use { 'kkoomen/vim-doge', run = ':call doge#install()',
        config = function()
            vim.g.dodge_doc_standard_python = 'google'
        end
    }

    -- }}}

    -- looking good {{{

    -- colorschemes {{{
    use { 'navarasu/onedark.nvim', opt = true }
    use { 'EdenEast/nightfox.nvim' }
    use { 'Shatur/neovim-ayu', opt = true }
    use {
        'projekt0n/github-nvim-theme',
        opt = true,
        config = function() require'github-theme'.setup { theme_style = 'dark' } end
    }
    use { 'rmehri01/onenord.nvim' }
    -- }}}

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', 'nvim-lua/lsp-status.nvim' },
        config = function() require 'statusline' end,
    }
    use {
        'gcmt/taboo.vim',
        config = function()
            vim.g.taboo_tab_format = " %I %f%m "
            vim.g.taboo_renamed_tab_format = " %I %l%m "
        end
    }
    use {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require("indent_blankline").setup {
                char = '│',
                show_current_context = true,
                buftype_exclude = { "terminal" }
            }
            vim.cmd [[highlight! link IndentBlanklineChar VertSplit]]
        end
    }
    use { 'https://gitlab.com/yorickpeterse/nvim-pqf.git', config = function() require('pqf').setup() end }
    use {
        'petertriho/nvim-scrollbar',
        requires = 'kevinhwang91/nvim-hlslens',
        config = function()
            require("scrollbar").setup { handle = { color = "#4C566A" } }
            require("hlslens").setup({
                require("scrollbar.handlers.search").setup()
            })

            vim.cmd([[
        augroup scrollbar_search_hide
        autocmd!
        autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
        augroup END
        ]])
        end
    }
    -- }}}

    -- prose {{{
    use { 'reedes/vim-wordy', opt = true, ft = { 'markdown', 'tex', 'latex' } }
    use { 'davidbeckingsale/writegood.vim', opt = true, ft = { 'tex', 'markdown', 'latex' } }
    use { 'folke/zen-mode.nvim', opt = true, cmd = 'ZenMode', config = function() require("zen-mode").setup {} end }
    -- }}}

    -- filetypes {{{

    -- python {{{
    use { 'vim-python/python-syntax', ft = { 'python' } }
    use { 'Vimjas/vim-python-pep8-indent', ft = { 'python' } }
    use { 'tmhedberg/SimpylFold', ft = { 'python' } }
    use { 'anntzer/vim-cython', ft = { 'python', 'cython' } }
    -- }}}

    use { 'adamclaxon/taskpaper.vim', opt = true, ft = { 'taskpaper', 'tp' } }
    use {
        'lervag/vimtex',
        opt = true,
        ft = 'tex',
        config = function()
            -- Latex options
            vim.g.vimtex_compiler_latexmk = { build_dir = './build' }
            vim.g.vimtex_quickfix_mode = 0
            vim.g.vimtex_view_method = 'skim'
            vim.g.vimtex_fold_enabled = 1
            vim.g.vimtex_compiler_progname = 'nvr'
        end,
        requires = { 'jbyuki/nabla.nvim' }
    }
    use { 'vim-scripts/scons.vim', opt = true, ft = { 'scons' } }
    use { 'Glench/Vim-Jinja2-Syntax', opt = true, ft = { 'html' } }
    use { 'mattn/emmet-vim', opt = true, ft = { 'html', 'css', 'sass', 'jinja.html' } }
    use { 'cespare/vim-toml', opt = true, ft = { 'toml' } }
    use { 'tikhomirov/vim-glsl', opt = true }
    use { 'DingDean/wgsl.vim', opt = true }
    use { 'snakemake/snakemake', rtp = 'misc/vim' }
    use 'NoahTheDuke/vim-just'
    use 'alaviss/nim.nvim'
    -- }}}

    if PACKER_BOOTSTRAP then
      require('packer').sync()
    end
end)

-- vim: set fdm=marker:
