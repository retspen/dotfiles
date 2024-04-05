local wezterm = require 'wezterm'

return {
 enable_tab_bar = false,
 hide_tab_bar_if_only_one_tab = true,
 window_close_confirmation = 'NeverPrompt',
 color_scheme = 'Dracula', 
 font = wezterm.font 'JetBrains Mono',
 font_size = 11.0,
 window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
 }
}
