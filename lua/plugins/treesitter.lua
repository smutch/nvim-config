return {
    {
        'nvim-treesitter/nvim-treesitter',
        requires = { "OXY2DEV/markview.nvim" },
        config = function() require 'plugins.config.treesitter' end
    },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    { 'nvim-treesitter/playground', cmd = 'TSPlaygroundToggle' },
}
