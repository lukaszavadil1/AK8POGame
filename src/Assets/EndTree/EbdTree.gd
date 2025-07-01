extends Node
func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "Player":  # or check by group or class
		get_tree().change_scene_to_file("res://Scenes/UpgradeScreen.tscn")
		print("Finished")
