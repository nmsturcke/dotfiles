vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.fn.argc() == 0 then
			vim.schedule(function()
				local ok, api = pcall(require, "nvim-tree.api")
				if ok then
					api.tree.open()
					-- Wait a bit for the window to open
					vim.defer_fn(function()
						-- Find nvim-tree window and resize it
						for _, win in ipairs(vim.api.nvim_list_wins()) do
							local buf = vim.api.nvim_win_get_buf(win)
							local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
							if ft == "NvimTree" then
								vim.api.nvim_win_set_width(win, 35) -- Set exact width
								break
							end
						end
						vim.cmd("wincmd l")
						vim.cmd("wincmd h")
					end, 50)
				end
			end)
		end
	end,
	nested = true,
})
