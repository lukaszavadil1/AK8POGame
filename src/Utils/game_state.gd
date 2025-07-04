extends Node

# Level tracking
var current_level: int = 1
const TOTAL_LEVELS: int = 5

# Time tracking
var level_start_time: float = 0.0
var level_completion_time: float = 0.0
var total_run_time: float = 0.0
var run_start_time: float = 0.0
var is_run_active: bool = false

func get_next_level_path() -> String:
	current_level += 1
	if is_final_level():
		return "res://Scenes/Main.tscn"
	else:
		return "res://Scenes/Levels/level_%d.tscn" % current_level

func reset() -> void:
	current_level = 1
	total_run_time = 0.0
	level_completion_time = 0.0
	run_start_time = 0.0
	level_start_time = 0.0
	is_run_active = false

func is_final_level() -> bool:
	return current_level > TOTAL_LEVELS
	
func start_run_timer():
	if not is_run_active:
		total_run_time = 0.0
		is_run_active = true
	level_start_time = Time.get_ticks_msec()
	
func complete_level():
	level_completion_time = (Time.get_ticks_msec() - level_start_time) / 1000.0
	total_run_time += level_completion_time
	
func get_current_level_time() -> float:
	return (Time.get_ticks_msec() - level_start_time) / 1000.0

func get_total_run_time() -> float:
	if is_run_active:
		return total_run_time + get_current_level_time()
	return total_run_time

func format_time(seconds: float) -> String:
	var minutes = floor(seconds / 60)
	var secs = fmod(seconds, 60)
	return "%02d:%05.2f" % [minutes, secs]
