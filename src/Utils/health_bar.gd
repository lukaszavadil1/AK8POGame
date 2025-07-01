extends CanvasLayer

@onready var bar: ColorRect = $HealthBar
@onready var text: Label = $HealthBarText

const BAR_WIDTH: float = 300.0

func update_health(current: float, base: float) -> void:
	var ratio = clamp(current / base, 0.0, 1.0)
	bar.size.x = BAR_WIDTH * ratio
	text.text = "%.0f / %.0f" % [current, base]
