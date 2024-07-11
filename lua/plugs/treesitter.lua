return {
    {
        'nvim-treesitter/nvim-treesitter',
        config = function() require 'plugs.config.treesitter' end
    },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    { 'nvim-treesitter/playground', cmd = 'TSPlaygroundToggle' },
}
