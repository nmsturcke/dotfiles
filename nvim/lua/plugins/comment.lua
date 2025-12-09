return function (use)
    -- Comment Toggling
    use {
        "numToStr/Comment.nvim",
        config = function ()
            require("Comment").setup()
        end
    }
end
