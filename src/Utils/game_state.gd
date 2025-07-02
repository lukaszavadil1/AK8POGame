extends Node

var current_level: int = 1
const TOTAL_LEVELS: int = 2

func get_next_level_path() -> String:
	if is_final_level():
		return "res://Scenes/Main.tscn"
	else:
		return "res://Scenes/Levels/level_%d.tscn" % (current_level + 1)

func reset() -> void:
	current_level = 1

func is_final_level() -> bool:
	return current_level > TOTAL_LEVELS
