require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",     -- one of "all", "language", or a list of languages
  highlight = {
    enable = false,              -- false will disable the whole extension
    -- disable = { "c", "rust" },  -- list of language that will be disabled
  },
  incremental_selection = {
      enable = true,
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
  navigation = {
      enable = true,
      keymaps = {
        goto_definition_lsp_fallback = "gsd",
        list_definitions = "gsD",
        goto_next_usage = "<a-*>",
        goto_previous_usage = "<a-#>",
      },
    },
}
