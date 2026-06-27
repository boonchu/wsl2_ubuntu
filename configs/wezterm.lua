-- ============================================================================
-- WEZTERM CONFIGURATION
-- ============================================================================
-- WezTerm is a GPU-accelerated terminal emulator written in Rust.
-- This config transforms WezTerm into a powerful terminal multiplexer,
-- combining features from tmux, Zellij, and iTerm2 into one cohesive setup.
--
-- MODULAR STRUCTURE:
--   helpers.lua    - Utility functions (is_vim, is_micro, cwd helpers)
--   theme.lua      - Color schemes and theme definitions
-- ============================================================================

local wezterm = require("wezterm")
local theme = require("theme")

local mux = wezterm.mux
local act = wezterm.action

-- These are vars to put things in later (i dont use em all yet)
local config = {}
local keys = {}
local mouse_bindings = {}
local launch_menu = {}

-- This is for newer wezterm vertions to use the config builder
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- TAB BAR
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 32

-- Default config settings
-- These are the default config settins needed to use Wezterm
-- Just add this and return config and that's all the basics you need
config.initial_cols = 182
config.initial_rows = 41

-- Color scheme, Wezterm has 100s of them you can see here:
-- https://wezfurlong.org/wezterm/colorschemes/index.html
config.color_scheme = "Ocean (dark) (terminal.sexy)"

-- This is my chosen font, we will get into installing fonts on windows later
config.font = wezterm.font_with_fallback({
	"JetBrains Mono",
	"Symbols Nerd Font Mono",
	"Noto Color Emoji",
})
config.font_size = 15
config.launch_menu = launch_menu

-- BACKGROUND OPACITY
config.window_background_opacity = 0.95
config.macos_window_background_blur = 90

-- WINDOW PADDING
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}

-- makes my cursor blink
config.default_cursor_style = "BlinkingBar"
config.disable_default_key_bindings = true

-- this adds the ability to use ctrl+v to paste the system clipboard
config.keys = {
	-- move left/right for windows pane
	{ key = "LeftArrow", mods = "SHIFT", action = act.MoveTabRelative(-1) },
	{ key = "RightArrow", mods = "SHIFT", action = act.MoveTabRelative(1) },
	-- Ctrl+Insert maps to Copy to Clipboard
	{
		key = "Insert",
		mods = "CTRL",
		action = wezterm.action.CopyTo("Clipboard"),
	},
	-- Shift+Insert maps to Paste from Clipboard
	{
		key = "Insert",
		mods = "SHIFT",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
	-- Clears both scrollback and the visible viewport
	{
		key = "k",
		mods = "CTRL", -- or 'CMD' if you prefer
		action = act.ClearScrollback("ScrollbackAndViewport"),
	},
}

-- PANE SPLIT LINE AND TAB BAR STYLING
config.colors = {
	split = theme.colors.pink,
	tab_bar = {
		background = theme.colors.bg,
		active_tab = {
			bg_color = theme.colors.bg_selection,
			fg_color = theme.colors.fg_bright,
			intensity = "Bold",
		},
		inactive_tab = {
			bg_color = theme.colors.bg,
			fg_color = theme.colors.fg_dim,
		},
		inactive_tab_hover = {
			bg_color = theme.colors.bg_light,
			fg_color = theme.colors.fg,
			italic = false,
		},
		new_tab = {
			bg_color = theme.colors.bg,
			fg_color = theme.colors.fg_dim,
		},
		new_tab_hover = {
			bg_color = theme.colors.bg_selection,
			fg_color = theme.colors.green,
		},
	},
}

-- split pane
wezterm.on("gui-startup", function(cwd)
	local project_dir = "/home/bigchoo/Documents/src"
	-- Spawn the initial window
	local tab, main_pane, window = wezterm.mux.spawn_window({
		cwd = project_dir .. "/ai_code_assistant/torch-gpu-app",
	})
	-- Split the main pane to the right (Horizontal Split)
	local right_pane = main_pane:split({
		direction = "Right",
		size = 0.45, -- 45% of the screen
		cwd = project_dir .. "/ai_code_assistant/docker-llama-cpp-app",
	})
	-- Create a bottom pane underneath the main pane
	local bottom_pane = right_pane:split({
		direction = "Bottom",
		size = 0.6, -- 60% of the screen
		cwd = project_dir .. "/ai_code_assistant/torch-gpu-app",
	})
	-- Optional: Send text to the new right pane automatically
	right_pane:send_text("figlet right\n")
	bottom_pane:send_text("figlet bottom\n")
end)

-- add status bar
wezterm.on("update-right-status", function(window, pane)
	-- Get the current foreground process name from the active pane
	local process = pane:get_foreground_process_name()
	-- Clean up the path to just show the executable name
	local clean_process = process and string.gsub(process, "(.*[/\\\\])(.*)", "%2") or "unknown"

	-- Display the active pane's ID and running process in the status bar
	window:set_right_status(wezterm.format({
		{ Background = { Color = "#333333" } },
		{ Foreground = { Color = "#FFA066" } },
		{ Text = " Pane ID: " .. pane:pane_id() .. " | Proc: " .. clean_process .. " " },
	}))
end)

-- Dim out inactive panes so you don't even need a divider line
config.inactive_pane_hsb = {
	saturation = 0.5,
	brightness = 0.2, -- Drops the brightness of the non-focused pane drastically
}

-- There are mouse binding to mimc Windows Terminal and let you copy
-- To copy just highlight something and right click. Simple
config.mouse_bindings = mouse_bindings
mouse_bindings = {
	{
		event = { Down = { streak = 3, button = "Left" } },
		action = wezterm.action.SelectTextAtMouseCursor("SemanticZone"),
		mods = "NONE",
	},
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action_callback(function(window, pane)
			local has_selection = window:get_selection_text_for_pane(pane) ~= ""
			if has_selection then
				window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
				window:perform_action(act.ClearSelection, pane)
			else
				window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
			end
		end),
	},
}

-- This is used to make my foreground (text, etc) brighter than my background
config.foreground_text_hsb = {
	hue = 1.0,
	saturation = 1.2,
	brightness = 1.5,
}

-- This is used to set an image as my background
config.background = {
	{
		source = { File = { path = "C:/Users/bigch/Downloads/XBOX.png", speed = 0.2 } },
		opacity = 1,
		width = "100%",
		hsb = { brightness = 0.5 },
	},
}

-- IMPORTANT: Sets WSL2 UBUNTU-22.04 as the defualt when opening Wezterm
config.default_domain = "WSL:Ubuntu"
config.front_end = "OpenGL"

-- Set WezTerm environment
-- config.hide_tab_bar_if_only_one_tab = true -- Hide WezTerm tabs since Zellij has its own
-- Automatically launch or attach to a Zellij session on startup
-- config.default_prog = { "zellij", "attach", "--create" }

return config
