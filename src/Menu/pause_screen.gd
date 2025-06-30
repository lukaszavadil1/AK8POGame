extends CanvasLayer

@export var player: CharacterBody2D = null

@onready var health_label = $ColorRect/Health as Label
@onready var stamina_label = $ColorRect/Stamina as Label
@onready var attack_label = $ColorRect/Attack as Label

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	if not player:
		player = get_parent().get_node("Player")

func update_stats_display():
	if not player:
		return 
	
	health_label.text = "Health: %.0f/%.0f" % [player.current_health, player.MAX_HEALTH]
	stamina_label.text = "Stamina: %.1f/%.1f" % [player.current_stamina, player.MAX_STAMINA]
	attack_label.text = "Attack: %d" % player.ATTACK_POWER

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and (event.keycode == KEY_P or event.keycode == KEY_ESCAPE):
		if visible:
			_resume_game()
		else:
			_pause_game()

func _pause_game() -> void:
	if not player:
		player = get_parent().get_node("Player")
	update_stats_display()
	visible = true
	get_tree().paused = true

func _resume_game() -> void:
	visible = false
	get_tree().paused = false


func _on_restart_pressed() -> void:
	_resume_game()
	get_tree().reload_current_scene()


func _on_back_to_menu_pressed() -> void:
	_resume_game()
	get_tree().change_scene_to_file("res://Menu/Main.tscn")
