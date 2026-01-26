vim.api.nvim_create_user_command("Theme", function(opts)
	vim.cmd("colorscheme " .. opts.args)

	local bg = vim.o.background -- this will be "dark" or "light"

	if bg == "dark" then
		vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#B3B3B3", bold = false })
		vim.api.nvim_set_hl(0, "LineNr", { fg = "#D3D3D3", bold = true })
		vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#B3B3B3", bold = false })
	else
		vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#4D4D4D", bold = false })
		vim.api.nvim_set_hl(0, "LineNr", { fg = "#262626", bold = true })
		vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#4D4D4D", bold = false })
	end
end, {
	nargs = 1,
	complete = function(ArgLead, _, _)
		return vim.fn.getcompletion(ArgLead, "color")
	end,
})

if vim.g.neovide then
	vim.g.neovide_cursor_animation_length = 0.150
	vim.g.neovide_cursor_trail_size = 0.9
	vim.g.neovide_normal_opacity = 1
	vim.g.neovide_cursor_vfx_mode = "pixiedust"

	vim.api.nvim_create_user_command("Opacity", function(opts)
		local args = opts.args
		if not args then
			-- Default
			args = 80
		end
		vim.g.neovide_normal_opacity = tonumber(args) / 100
	end, { nargs = "?" })

	vim.api.nvim_create_user_command("O", function(opts)
		vim.cmd("Opacity " .. opts.args)
	end, { nargs = "?" })
end
