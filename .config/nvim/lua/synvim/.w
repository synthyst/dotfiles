return {
  "sphamba/smear-cursor.nvim",
  event = "InsertEnter",
  opts = {
    legacy_computing_symbols_support = false,
    smear_between_buffers = true,
    smear_insert_mode = true,
    cursor_color = "#dbdbff",
    stiffness = 0.2,
    stiffness_insert_mode = 0.2,
    trailing_stiffness_insert_mode = 0.2,
    trailing_stiffness = 0.2,
    trailing_exponent = 5,
    damping = 0.6,
    gradient_exponent = 0,
    gamma = 1,
    never_draw_over_target = true, -- if you want to actually see under the cursor
    hide_target_hack = true,       -- same
  },
}
