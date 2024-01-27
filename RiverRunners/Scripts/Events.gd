extends Node

signal input_move_right
signal input_move_left
signal input_dash_right
signal input_dash_left
signal input_jump
signal input_throw
signal input_shield

signal start_score
signal player_position(position)
signal player_speed(speed)

signal camera_status(position,zoom)

signal otter_position(position)
signal crab_shield()

signal damage_taken(damage)
signal lose_damage(damage)
signal health_changed(currentHealth)

signal is_on_air(on_air)
signal can_jump(jump)
signal dashing
signal pauseSalmonCooldown
signal resumeSalmonCooldown
signal blocking
signal pauseCrabCooldown
signal resumeCrabCooldown
signal throwing
signal pauseOtterCooldown
signal resumeOtterCooldown

signal log_collided
signal is_lane_free(lane_offset: int, status: bool)
signal move_to_free_lane
signal collision_with_tree(area)
signal player_drowned

signal on_dialog_start
signal on_dialog_end

signal showTutorial(ability)

signal changeMusic(mode: String)

signal pause_game
signal player_died
signal resume_game
signal obstacles_ended
signal level_completed
signal new_level_completed

signal input_confirm
signal input_return

#switching scenes
signal go_to_main_menu
signal go_to_mode_select
signal go_to_level_select
signal go_to_level(level_id: String)
signal go_to_next_level
signal go_to_options
signal go_to_credits
signal go_to_previous_screen
signal go_from_main_menu_to_credits
signal go_from_credits_to_main_menu

signal show_loading_screen
signal hide_loading_screen
signal loading_screen_closed
signal loading_screen_opened
