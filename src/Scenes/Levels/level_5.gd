extends Node2D

func _ready() -> void:
	MusicManager.play_music(load("res://Assets/Sounds/Finale.wav"))
