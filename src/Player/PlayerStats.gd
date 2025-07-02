extends Node

var health: float = 100.0
var base_health: float = 100.0
var stamina: float = 16.0
var base_stamina: float = 16.0
var attack: float = 10.0
var upgrade_points: int = 0
var kill_count: int = 0

func reset():
	base_health = 100.0
	health = base_health
	base_stamina = 16.0
	stamina = base_stamina
	attack = 10.0
	upgrade_points = 0
	kill_count = 0
	
	
func add_points(points: int) -> void:
	upgrade_points += points
