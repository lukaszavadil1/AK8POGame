extends Node2D


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	GameState.start_run_timer()
	get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")


func _on_controls_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/ControlsScreen.tscn")
