extends Node

var current_level: int = 1
const TOTAL_LEVELS := 2

func get_next_level_path() -> String:
	if current_level <= TOTAL_LEVELS:
		return "res://Scenes/Levels/level_%d.tscn" % (current_level + 1)
	else:
		return "res://Scenes/Main.tscn"

func reset():
	current_level = 1
