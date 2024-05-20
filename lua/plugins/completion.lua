return {
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            { 'Saecki/crates.nvim',         config = true,   ft = { "rust", "toml" } },
            'hrsh7th/cmp-nvim-lua',
            { 'kdheepak/cmp-latex-symbols', ft = { "latex" } },
            'f3fora/cmp-spell',
            'hrsh7th/cmp-calc',
            'ray-x/cmp-treesitter',
            'hrsh7th/cmp-omni',
            'hrsh7th/cmp-cmdline',
            'lukas-reineke/cmp-under-comparator',
            'saadparwaiz1/cmp_luasnip',
            'jmbuhr/otter.nvim',
        },
        config = function() require 'completion' end
    }
}
