extends Control

@onready var bar: ColorRect = $StaminaBar

const BAR_WIDTH = 16.0

func update_stamina(current: float, base: float) -> void:
	var ratio = clamp(current / base, 0.0, 1.0)
	bar.size.x = BAR_WIDTH * ratio
