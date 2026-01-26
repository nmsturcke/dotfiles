-- Bootstrap packer
local ensure_packer = function()
	local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
		vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	-- Automatically load all plugins in the plugins directory

	local plugin_dir = vim.fn.stdpath("config") .. "/lua/plugins"
	local plugin_files = vim.fn.globpath(plugin_dir, "*.lua", false, true)

	for _, file in ipairs(plugin_files) do
		local module_name = vim.fn.fnamemodify(file, ":t:r")
		if module_name ~= "init" then
			local ok, plugin_func = pcall(require, "plugins." .. module_name)
			if ok then
				if type(plugin_func) == "function" then
					plugin_func(use)
				else
					print("ERROR: " .. module_name .. " did not return a function, got: " .. type(plugin_func))
				end
			else
				print("ERROR loading " .. module_name .. ": " .. plugin_func)
			end
		end
	end
	if packer_bootstrap then
		require("packer").sync()
	end
end)
