local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

local is_macos = wezterm.target_triple:find("darwin") ~= nil

config.term = "xterm-256color"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.window_background_opacity = 0.9
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.colors = {
  foreground = "#d8dee9",
  background = "#2e3440",
  cursor_bg = "#d8dee9",
  cursor_fg = "#2e3440",
  selection_bg = "#4c566a",
  selection_fg = "#d8dee9",
  ansi = {
    "#3b4252",
    "#bf616a",
    "#a3be8c",
    "#ebcb8b",
    "#81a1c1",
    "#b48ead",
    "#88c0d0",
    "#e5e9f0",
  },
  brights = {
    "#4c566a",
    "#bf616a",
    "#a3be8c",
    "#ebcb8b",
    "#81a1c1",
    "#b48ead",
    "#8fbcbb",
    "#eceff4",
  },
}

if is_macos then
  config.font = wezterm.font("Monaco")
  config.font_size = 14.6
  config.window_decorations = "RESIZE"
else
  config.font = wezterm.font("Source Code Pro")
  config.font_size = 8.5
  config.window_decorations = "TITLE|RESIZE"
  config.default_prog = { "/usr/bin/zsh", "--login" }
end

return config
