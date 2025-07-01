extends Node

var health := 100.0
var base_health := 100.0
var stamina := 16.0
var base_stamina := 16.0
var attack := 10.0
var upgrade_points := 10

func reset():
	base_health = 100.0
	health = base_health
	base_stamina = 16.0
	stamina = base_stamina
	attack = 10.0
	upgrade_points = 10
