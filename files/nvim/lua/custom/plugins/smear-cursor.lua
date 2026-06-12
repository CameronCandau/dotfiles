return {
  'sphamba/smear-cursor.nvim',
  commit = '2d1552a0fe8bb3b5f11db5ce84a7df2be25d7f66',

  opts = {
    -- Smear cursor color. Defaults to Cursor GUI color if not set.
    -- Set to "none" to match the text color at the target cursor position.
    cursor_color = '#f5e0dc',

    -- Background color. Defaults to Normal GUI background color if not set.
    normal_bg = '#282828',

    -- Smear cursor when switching buffers or windows.
    smear_between_buffers = true,

    -- Smear cursor when moving within line or to neighbor lines.
    smear_between_neighbor_lines = true,

    -- Draw the smear in buffer space instead of screen space when scrolling
    scroll_buffer_space = true,

    -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
    -- Smears will blend better on all backgrounds.
    legacy_computing_symbols_support = false,

    -- Fast cursor
    -- stiffness = 0.8, -- 0.6      [0, 1]
    -- trailing_stiffness = 0.5, -- 0.3      [0, 1]
    -- distance_stop_animating = 0.5, -- 0.1      > 0
    -- hide_target_hack = false, -- true     boolean
  },
}
