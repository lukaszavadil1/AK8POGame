extends CanvasLayer


@onready var fill = $HealthBar
@onready var percent = $HealthBarText
var max_width: float = 300.0
var new_val = 100.0

func update_health(value: float, max_value: float):
	new_val = (value / max_value) * max_width
	fill.size.x = new_val
	percent.text = str(new_val) + " %"
