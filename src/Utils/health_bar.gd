extends CanvasLayer


@onready var fill = $HealthBar
@onready var percent = $HealthBarText
var max_width: float = 300.0

func update_health(value: float, max_value: float):
	var health_percentage = (value / max_value) * 100
	fill.size.x = (value / max_value) * max_width
	percent.text = "%.0f %%" % health_percentage
