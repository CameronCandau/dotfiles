local wezterm = require 'wezterm'
local act = wezterm.action

local config = wezterm.config_builder()

config.initial_cols = 120
config.initial_rows = 28
config.max_fps = 144
config.hide_tab_bar_if_only_one_tab = true
config.audible_bell = 'Disabled'
config.enable_kitty_graphics = true
config.font_size = 14
config.color_scheme = 'Catppuccin Mocha'
config.pane_focus_follows_mouse = true
config.scrollback_lines = 100000
config.status_update_interval = 5000

wezterm.on('toggle-colors', function(window, _)
  local overrides = window:get_config_overrides() or {}

  if overrides.color_scheme == 'Builtin Light' then
    overrides.color_scheme = 'Catppuccin Mocha'
  else
    overrides.color_scheme = 'Builtin Light'
  end

  window:set_config_overrides(overrides)
end)

config.keys = {
  {
    key = 'i',
    mods = 'ALT|SHIFT|CTRL',
    action = act.EmitEvent('toggle-colors'),
  },
  {
    key = 'y',
    mods = 'ALT|SHIFT|CTRL',
    action = act.ActivateCopyMode,
  },
  {
    key = 'f',
    mods = 'ALT|SHIFT|CTRL',
    action = act.Search 'CurrentSelectionOrEmptyString',
  },
  {
    key = 'p',
    mods = 'ALT|SHIFT|CTRL',
    action = act.ScrollToPrompt(-1),
  },
  {
    key = 'j',
    mods = 'ALT|SHIFT|CTRL',
    action = act.ScrollToPrompt(1),
  },
}

wezterm.on('update-status', function(window, _)
  local vpn_status = 'VPN:DOWN '
  local vpn_color = '#f38ba8'
  local success, stdout = wezterm.run_child_process({ 'ip', 'addr', 'show', 'tun0' })

  if success then
    local ip = stdout:match('inet (%d+%.%d+%.%d+%.%d+)')
    if ip then
      vpn_status = 'VPN:' .. ip .. ' '
      vpn_color = '#a6e3a1'
    end
  end

  window:set_right_status(wezterm.format {
    { Attribute = { Intensity = 'Bold' } },
    { Foreground = { Color = vpn_color } },
    { Text = vpn_status },
  })
end)

return config
