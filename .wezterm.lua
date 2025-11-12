-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- Import the action module
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Helper function to create a workspace with a specific layout
local function create_workspace_with_layout(name, layout_type)
  return wezterm.action_callback(function(window, pane)
    -- Create the workspace
    window:perform_action(
      act.SwitchToWorkspace {
        name = name,
      },
      pane
    )

    -- Apply layout based on type
    if layout_type == 'pentest' then
      -- Create a 3-tab setup: enum, exploit, shell
      window:perform_action(act.SpawnTab 'CurrentPaneDomain', pane)
      window:perform_action(act.SpawnTab 'CurrentPaneDomain', pane)

      -- Name the tabs
      local tabs = window:mux_window():tabs()
      if tabs[1] then tabs[1]:set_title('enum') end
      if tabs[2] then tabs[2]:set_title('exploit') end
      if tabs[3] then tabs[3]:set_title('shell') end

      -- Go back to first tab
      window:perform_action(act.ActivateTab(0), pane)
    end
  end)
end

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

config.max_fps = 144
-- config.front_end = "Software" -- Necessary in virtualized environments like VMs without a GPU

-- Show tab bar always to display workspace names and tab titles
config.hide_tab_bar_if_only_one_tab = false

config.audible_bell = 'Disabled'

-- Enable kitty graphics protocol
config.enable_kitty_graphics = true

config.font_size = 14

-- Default theme
config.color_scheme = "Catppuccin Mocha"

wezterm.on("toggle-colors", function(window, pane)
  local overrides = window:get_config_overrides() or {}

  if overrides.color_scheme == "Builtin Light" then
    overrides.color_scheme = "Catppuccin Mocha"
  else
    overrides.color_scheme = "Builtin Light"
  end

  window:set_config_overrides(overrides)
end)

-- Add keybindings

config.pane_focus_follows_mouse = true


config.keys = {
  {
    key = "i",
    mods = "ALT|SHIFT|CTRL",
    action = wezterm.action.EmitEvent("toggle-colors"),
  },

  -- Workspaces
  {
    key = 's',
    mods = 'ALT|SHIFT|CTRL',
    action = act.ShowLauncherArgs {
      flags = 'FUZZY|WORKSPACES',
    },
  },
  {
    key = 'n',
    mods = 'ALT|SHIFT|CTRL',
    action = act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { AnsiColor = 'Fuchsia' } },
        { Text = 'Enter name for new workspace' },
      },
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(
            act.SwitchToWorkspace {
              name = line,
            },
            pane
          )
        end
      end),
    },
  },
  {
    key = 'r',
    mods = 'ALT|SHIFT|CTRL',
    action = act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { AnsiColor = 'Fuchsia' } },
        { Text = 'Enter new name for workspace' },
      },
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          wezterm.mux.rename_workspace(
            wezterm.mux.get_active_workspace(),
            line
          )
        end
      end),
    },
  },
  {
    key = 'd',
    mods = 'ALT|SHIFT|CTRL',
    action = wezterm.action_callback(function(window, pane)
      local workspace_name = window:active_workspace()
      -- Confirm before deleting workspace
      window:perform_action(
        act.PromptInputLine {
          description = wezterm.format {
            { Attribute = { Intensity = 'Bold' } },
            { Foreground = { AnsiColor = 'Red' } },
            { Text = 'Delete workspace "' .. workspace_name .. '"? Type YES to confirm:' },
          },
          action = wezterm.action_callback(function(window, pane, line)
            if line == 'YES' then
              -- Close all tabs in the current workspace by switching to default and closing all tabs
              local mux = wezterm.mux
              local default_workspace = 'default'

              -- Switch to default workspace first
              window:perform_action(
                act.SwitchToWorkspace {
                  name = default_workspace,
                },
                pane
              )

              -- Get all tabs in the workspace we want to delete
              for _, tab_info in ipairs(mux.get_workspace(workspace_name):tabs()) do
                tab_info:kill()
              end
            end
          end),
        },
        pane
      )
    end),
  },
  -- Workspace navigation
  {
    key = 'Tab',
    mods = 'ALT|SHIFT|CTRL',
    action = act.SwitchWorkspaceRelative(1),
  },
  {
    key = 'Tab',
    mods = 'ALT|SHIFT',
    action = act.SwitchWorkspaceRelative(-1),
  },
  -- Quick workspace template
  {
    key = 'm',
    mods = 'ALT|SHIFT|CTRL',
    action = act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { AnsiColor = 'Fuchsia' } },
        { Text = 'Machine name/IP for pentest workspace:' },
      },
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          create_workspace_with_layout(line, 'pentest')(window, pane)
        end
      end),
    },
  },

  -- Tabs
  {
    key = 't',
    mods = 'ALT|SHIFT|CTRL',
    action = act.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'w',
    mods = 'ALT|SHIFT|CTRL',
    action = act.CloseCurrentTab { confirm = true },
  },
  {
    key = 'e',
    mods = 'ALT|SHIFT|CTRL',
    action = act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { AnsiColor = 'Fuchsia' } },
        { Text = 'Enter new name for tab' },
      },
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
  {
    key = '1',
    mods = 'ALT|SHIFT|CTRL',
    action = wezterm.action.ActivateTab(0),
  },
  {
    key = '2',
    mods = 'ALT|SHIFT|CTRL',
    action = wezterm.action.ActivateTab(1),
  },
  {
    key = '3',
    mods = 'ALT|SHIFT|CTRL',
    action = wezterm.action.ActivateTab(2),
  },
  {
    key = '4',
    mods = 'ALT|SHIFT|CTRL',
    action = wezterm.action.ActivateTab(3),
  },
  {
    key = '5',
    mods = 'ALT|SHIFT|CTRL',
    action = wezterm.action.ActivateTab(4),
  },
  {
    key = '6',
    mods = 'ALT|SHIFT|CTRL',
    action = wezterm.action.ActivateTab(5),
  },
  {
    key = '7',
    mods = 'ALT|SHIFT|CTRL',
    action = wezterm.action.ActivateTab(6),
  },
  {
    key = '8',
    mods = 'ALT|SHIFT|CTRL',
    action = wezterm.action.ActivateTab(7),
  },
  {
    key = '9',
    mods = 'ALT|SHIFT|CTRL',
    action = wezterm.action.ActivateTab(8),
  },
  {
    key = '0',
    mods = 'ALT|SHIFT|CTRL',
    action = wezterm.action.ActivateTab(9),
  },




  -- Panes
  {
    key = 'h',
    mods = 'ALT|SHIFT|CTRL',
    action = wezterm.action.SplitPane { direction = 'Left', size = { Percent = 50 } },
  },
  {
    key = 'v',
    mods = 'ALT|SHIFT|CTRL',
    action = wezterm.action.SplitPane { direction = 'Down', size = { Percent = 50 } },
  },
  {
    key = 'x',
    mods = 'ALT|SHIFT|CTRL',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  {
    key = 'f',
    mods = 'ALT|SHIFT|CTRL',
    action = wezterm.action.TogglePaneZoomState,
  },

  --- Navigation
  {
    key = 'h',
    mods = 'ALT',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'l',
    mods = 'ALT',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  {
    key = 'k',
    mods = 'ALT',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key = 'j',
    mods = 'ALT',
    action = wezterm.action.ActivatePaneDirection 'Down',
  },

  -- Pane resizing
  {
    key = 'LeftArrow',
    mods = 'ALT|SHIFT|CTRL',
    action = wezterm.action.AdjustPaneSize { 'Left', 5 },
  },
  {
    key = 'RightArrow',
    mods = 'ALT|SHIFT|CTRL',
    action = wezterm.action.AdjustPaneSize { 'Right', 5 },
  },
  {
    key = 'UpArrow',
    mods = 'ALT|SHIFT|CTRL',
    action = wezterm.action.AdjustPaneSize { 'Up', 5 },
  },
  {
    key = 'DownArrow',
    mods = 'ALT|SHIFT|CTRL',
    action = wezterm.action.AdjustPaneSize { 'Down', 5 },
  },

  -- Copy mode for easy text selection (useful for hashes, credentials, etc)
  {
    key = 'y',
    mods = 'ALT|SHIFT|CTRL',
    action = act.ActivateCopyMode,
  },
  -- Quick search for common patterns
  {
    key = 'f',
    mods = 'ALT|SHIFT|CTRL',
    action = act.Search 'CurrentSelectionOrEmptyString',
  },

}

-- Custom tab title format to show renamed titles and workspace names
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local title = tab.tab_title
  -- If the tab has an explicit title (set via rename), use it
  if title and #title > 0 then
    return {
      { Text = ' ' .. title .. ' ' },
    }
  end

  -- Otherwise fall back to the active pane title
  title = tab.active_pane.title
  return {
    { Text = ' ' .. title .. ' ' },
  }
end)

-- Show workspace name and VPN status in the right status area
wezterm.on('update-right-status', function(window, pane)
  local workspace = window:active_workspace()

  -- Check for VPN connection (tun0 interface)
  local vpn_status = ''
  local vpn_color = '#f38ba8' -- Catppuccin Mocha red (disconnected)
  local success, stdout, stderr = wezterm.run_child_process({ 'ip', 'addr', 'show', 'tun0' })

  if success then
    -- Extract IP from tun0 interface
    local ip = stdout:match('inet (%d+%.%d+%.%d+%.%d+)')
    if ip then
      vpn_status = 'VPN:' .. ip .. ' '
      vpn_color = '#a6e3a1' -- Catppuccin Mocha green (connected)
    else
      vpn_status = 'VPN:DOWN '
    end
  else
    vpn_status = 'VPN:DOWN '
  end

  window:set_right_status(wezterm.format {
    { Attribute = { Intensity = 'Bold' } },
    { Foreground = { Color = vpn_color } },
    { Text = vpn_status },
    { Foreground = { Color = '#cba6f7' } }, -- Catppuccin Mocha mauve
    { Text = '[' .. workspace .. '] ' },
  })
end)

return config