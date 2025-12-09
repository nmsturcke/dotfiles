return function(use)
    use {
        "akinsho/bufferline.nvim",
        requires = "nvim-tree/nvim-web-devicons",
        config = function()
            require("bufferline").setup()
        end
    }
end
