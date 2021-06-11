require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",     -- one of "all", "language", or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    -- disable = { "c", "rust" },  -- list of language that will be disabled
    custom_captures = {
        ["variable"] = "Normal",
    },
  },
  incremental_selection = {
      enable = false,
      keymaps = {
          init_selection = "gsi",
          node_incremental = "gn",
          scope_incremental = "gc",
          node_decremental = "gN",
          scope_decremental = "gC",
      },
  },
  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = true },
    smart_rename = {
        enable = true,
        keymaps = {
            smart_rename = "gsr",
        },
    },
  },
  }
