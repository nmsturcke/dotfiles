return function(use)
	use("IogaMaster/neocord")

	local cwd = vim.fn.getcwd()
	local neocord_file = cwd .. "/.nvim/neocord.yml"
	local neocord_configuration = {
		enabled = true,
		show_time = true, -- Show the timer when the activity starts (boolean)
		-- Rich Presence text options
		editing_text = "Editing %s", -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
		file_explorer_text = "Browsing %s", -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
		git_commit_text = "Committing changes", -- Format string rendered when committing changes in git (either string or function(filename: string): string)
		plugin_manager_text = "Managing plugins", -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
		reading_text = "Reading %s", -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
		workspace_text = "Working on %s", -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
		line_number_text = "Line %s out of %s", -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
	}

	-- Read configuration from .nvim/neocord.yml if it exists
	-- Update neocord_configuration table accordingly, expecting simple key: value pairs
	-- If keys are missing, defaults from above are used
	function parse_neocord_lines(lines)
		for line in lines do
			local key, value = line:match("^(%S+):%s*(%S+)$")
			if key and value then
				if key == "preset" then
					if value == "work" then
						neocord_configuration = {
							enabled = true,
							show_time = false,
							editing_text = "Editing code",
							file_explorer_text = "Browsing project files",
							git_commit_text = "Committing changes",
							plugin_manager_text = "Managing plugins",
							reading_text = "Reading documentation",
							workspace_text = "Working for a client",
							line_number_text = "Line %s out of %s",
						}
					end
				end
				if value == "true" then
					neocord_configuration[key] = true
				elseif value == "false" then
					neocord_configuration[key] = false
				else
					neocord_configuration[key] = value
				end
			end
		end
	end

	if vim.fn.filereadable(neocord_file) == 1 then
		local file = io.open(neocord_file, "r")
		if file then
			parse_neocord_lines(file:lines())
			file:close()
		end
	end

	if neocord_configuration.enabled == true then
		-- The setup config table shows all available config options with their default values:

		require("neocord").setup({
			-- General options
			auto_update = true, -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
			logo = "file", -- Main image display (either "neovim" or "file")
			logo_tooltip = "Neovide", -- Tooltip text when hovering over the main image
			client_id = "736954138965049395", -- Use your own Discord application client id (not recommended)
			log_level = nil, -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
			debounce_timeout = 10, -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
			enable_line_number = false, -- Displays the current line number instead of the current project
			blacklist = {}, -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
			buttons = {
				{
					label = "GitHub",
					url = "https://github.com/nmsturcke",
				},
			}, -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
			file_assets = {}, -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
			show_time = neocord_configuration.show_time, -- Show the timer when the activity starts

			-- Rich Presence text options
			editing_text = neocord_configuration.editing_text,
			file_explorer_text = neocord_configuration.file_explorer_text,
			git_commit_text = neocord_configuration.git_commit_text,
			plugin_manager_text = neocord_configuration.plugin_manager_text,
			reading_text = neocord_configuration.reading_text,
			workspace_text = neocord_configuration.workspace_text,
			line_number_text = neocord_configuration.line_number_text,
		})
	end

	-- Create user commands for Neovim.
	-- A. Command to toggle Neocord presence on and off. This also updates the .nvim/neocord.yml file accordingly.
	vim.api.nvim_create_user_command("NeocordToggle", function()
		local presence = require("neocord")
		neocord_configuration.enabled = not neocord_configuration.enabled

		if neocord_configuration.enabled then
			presence:setup(neocord_configuration)
			print("Neocord presence enabled.")
		else
			presence:shutdown()
			print("Neocord presence disabled.")
		end

		-- Update the .nvim/neocord.yml file
		local cwd = vim.fn.getcwd()
		local neocord_file = cwd .. "/.nvim/neocord.yml"
		local file = io.open(neocord_file, "w")
		if file then
			for key, value in pairs(neocord_configuration) do
				file:write(string.format("%s: %s\n", key, tostring(value)))
			end
			file:close()
		end
	end, {})
	-- B. Command to save current Neocord configuration to .nvim/neocord.yml
	vim.api.nvim_create_user_command("NeocordSaveConfig", function()
		local cwd = vim.fn.getcwd()
		local neocord_file = cwd .. "/.nvim/neocord.yml"
		local file = io.open(neocord_file, "w")
		if file then
			for key, value in pairs(neocord_configuration) do
				file:write(string.format("%s: %s\n", key, tostring(value)))
			end
			file:close()
			print("Neocord configuration saved to " .. neocord_file)
		else
			print("Error: Could not open " .. neocord_file .. " for writing.")
		end
	end, {})
	-- C. Manually update Neocord from .nvim/neocord.yml
	vim.api.nvim_create_user_command("NeocordUpdateConfig", function()
		local cwd = vim.fn.getcwd()
		local neocord_file = cwd .. "/.nvim/neocord.yml"
		local file = io.open(neocord_file, "r")
		if file then
			parse_neocord_lines(file:lines())

			file:close()
			-- Re-setup Neocord with the new configuration
			if neocord_configuration.enabled then
				require("neocord").setup(neocord_configuration)
			end
			print("Neocord configuration updated from " .. neocord_file)
		else
			print("Error: Could not open " .. neocord_file .. " for reading.")
		end
	end, {})
end
