extends CanvasLayer

@onready var health_label = $ColorRect/Health as Label
@onready var stamina_label = $ColorRect/Stamina as Label
@onready var attack_label = $ColorRect/Attack as Label
@onready var upgrade_points_label = $ColorRect/UpgradePoints as Label

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func update_stats_display():
	health_label.text = "Health: %.0f/%.0f" % [PlayerState.health, PlayerState.base_health]
	stamina_label.text = "Stamina: %.1f/%.1f" % [PlayerState.stamina, PlayerState.base_stamina]
	attack_label.text = "Attack: %d" % PlayerState.attack
	upgrade_points_label.text = "Upgrade points: %d (%d kills)" % [PlayerState.upgrade_points, PlayerState.kill_count]

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and (event.keycode == KEY_P or event.keycode == KEY_ESCAPE):
		if visible:
			_resume_game()
		else:
			_pause_game()

func _pause_game() -> void:
	update_stats_display()
	visible = true
	get_tree().paused = true

func _resume_game() -> void:
	visible = false
	get_tree().paused = false


func _on_restart_pressed() -> void:
	_resume_game()
	PlayerState.stamina = PlayerState.base_stamina
	PlayerState.health = PlayerState.base_health
	get_tree().reload_current_scene()

func _on_back_to_menu_pressed() -> void:
	_resume_game()
	PlayerState.reset()
	GameState.reset()
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
