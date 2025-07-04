extends Node

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "Player":
		GameState.complete_level()
		call_deferred("_change_scene")

func _change_scene():
	if GameState.current_level == 5:
		get_tree().change_scene_to_file("res://Scenes/GameOverScreen.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/UpgradeScreen.tscn")
