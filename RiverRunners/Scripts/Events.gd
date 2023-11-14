extends Node

signal input_move_right
signal input_move_left
signal input_dash_right
signal input_dash_left
signal input_jump
signal input_throw
signal input_shield

signal pause_game

signal player_position(position)
signal player_speed(speed)

signal otter_position(position)

signal damage_taken(damage)
signal lose_damage(damage)
signal health_changed(currentHealth)

signal is_on_air(on_air)
signal can_jump(jump)

signal log_collided
signal is_lane_free(lane_offset: int, status: bool)