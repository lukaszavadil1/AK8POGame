extends CanvasLayer

@onready var kills_label = $Kills
@onready var health_label = $Health
@onready var attack_label = $Attack
@onready var stamina_label = $Stamina
@onready var level_time_label = $LevelTime
@onready var total_time_label = $TotalTime

func _ready():
	update_ui()
	level_time_label.text = "Level Time: " + GameState.format_time(GameState.level_completion_time)
	total_time_label.text = "Total Time: " + GameState.format_time(GameState.total_run_time)

func update_ui():
	kills_label.text = "Total kills: %d" % PlayerState.kill_count
	health_label.text = "Health: %d" % PlayerState.base_health
	attack_label.text = "Attack: %d" % PlayerState.attack
	stamina_label.text = "Stamina: %d" % PlayerState.base_stamina

func _on_back_to_menu_pressed() -> void:
	GameState.reset()
	PlayerState.reset()
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
