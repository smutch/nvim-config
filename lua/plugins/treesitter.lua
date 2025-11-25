return {
    {
        'nvim-treesitter/nvim-treesitter',
        config = function() require 'plugins.config.treesitter' end
    },
    { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
    { 'nvim-treesitter/playground', cmd = 'TSPlaygroundToggle' },
}
