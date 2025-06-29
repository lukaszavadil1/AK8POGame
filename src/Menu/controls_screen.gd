extends Node2D


func _ready() -> void:
	$ControlsContainer/BackButton.grab_focus()


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/Main.tscn")
