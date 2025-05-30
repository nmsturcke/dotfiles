if vim.g.neovide then
    vim.g.neovide_cursor_animation_length = 0.150
    vim.g.neovide_cursor_trail_size = 0.9
    vim.g.neovide_normal_opacity = 1 
    vim.g.neovide_cursor_vfx_mode= "pixiedust"
    vim.cmd("colorscheme ayu-mirage")

    vim.api.nvim_create_user_command("Opacity", function (opts)
        local args = opts.args
        if not args then
            -- Default
            args = 80
        end
        vim.g.neovide_normal_opacity = tonumber(tonumber(args) / 100)
    end, { nargs = "?" })

    vim.api.nvim_create_user_command("O", function (opts)
        vim.cmd("Opacity " .. opts.args)
    end, { nargs = "?" })
else
    require('ayu').setup({
        overrides = {
            Normal = { bg = "None"}, --None"}, --  #1F24300F" },
            -- NormalFloat = { bg = "none" },
            -- ColorColumn = { bg = "None" },
            -- SignColumn = { bg = "None" },
            -- Folded = { bg = "None" },
            -- FoldColumn = { bg = "None" },
            -- CursorLine = { bg = "None" },
            -- CursorColumn = { bg = "None" },
            -- VertSplit = { bg = "None" },
        },
    })

    vim.cmd("colorscheme ayu-mirage")
end
