extends Control

@onready var fill = $StaminaBar
var max_width: float = 16.0

func update_stamina(value: float, max_value: float):
	fill.size.x = (value / max_value) * max_width
