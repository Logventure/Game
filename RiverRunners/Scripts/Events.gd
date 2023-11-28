extends Node

signal input_move_right
signal input_move_left
signal input_dash_right
signal input_dash_left
signal input_jump
signal input_throw
signal input_shield

signal player_position(position)
signal player_speed(speed)

signal camera_status(position,zoom)

signal otter_position(position)

signal damage_taken(damage)
signal lose_damage(damage)
signal health_changed(currentHealth)

signal is_on_air(on_air)
signal can_jump(jump)

signal log_collided
signal is_lane_free(lane_offset: int, status: bool)

signal on_dialog_start
signal on_dialog_end

signal pause_game
signal player_died
signal resume_game

signal input_confirm
signal input_return

signal on_rock_area_entered

#switching scenes
signal go_to_main_menu
signal go_to_mode_select
signal go_to_level_select
signal go_to_level(level_id: String)
signal go_to_options
signal go_to_previous_screen
