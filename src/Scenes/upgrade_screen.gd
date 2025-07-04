extends CanvasLayer

@onready var level_title_label = $Title
@onready var upgrade_points_label = $UpgradePoints
@onready var health_label = $Health
@onready var attack_label = $Attack
@onready var stamina_label = $Stamina
@onready var level_time_label = $LevelTime
@onready var total_time_label = $TotalTime
@onready var upgrade_health_button = $UpgradeHealth
@onready var upgrade_attack_button = $UpgradeAttack
@onready var upgrade_stamina_button = $UpgradeStamina

func _ready():
	update_ui()
	level_time_label.text = "Level Time: " + GameState.format_time(GameState.level_completion_time)
	total_time_label.text = "Total Time: " + GameState.format_time(GameState.total_run_time)
	PlayerState.stamina = PlayerState.base_stamina
	PlayerState.health = PlayerState.base_health

func update_ui():
	upgrade_points_label.text = "Upgrade points: %d (%d kills)" % [PlayerState.upgrade_points, PlayerState.kill_count]
	health_label.text = "Health: %d" % PlayerState.base_health
	attack_label.text = "Attack: %d" % PlayerState.attack
	stamina_label.text = "Stamina: %d" % PlayerState.base_stamina
	level_title_label.text = "Level %d completed!" % GameState.current_level
	
	var can_upgrade = PlayerState.upgrade_points > 0
	upgrade_health_button.disabled = not can_upgrade
	upgrade_attack_button.disabled = not can_upgrade
	upgrade_stamina_button.disabled = not can_upgrade

func try_upgrade(stat: String, amount: float):
	if PlayerState.upgrade_points > 0:
		match stat:
			"health":
				PlayerState.base_health += amount
			"stamina":
				PlayerState.base_stamina += amount
			"attack":
				PlayerState.attack += amount
		PlayerState.upgrade_points -= 1
		update_ui()

func _on_upgrade_health_pressed() -> void:
	try_upgrade("health", 10)

func _on_upgrade_stamina_pressed() -> void:
	try_upgrade("stamina", 5)

func _on_upgrade_attack_pressed() -> void:
	try_upgrade("attack", 2)

func _on_back_to_menu_pressed() -> void:
	PlayerState.reset()
	GameState.reset()
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")

func _on_next_level_pressed() -> void:
	GameState.level_start_time = Time.get_ticks_msec()
	get_tree().change_scene_to_file(GameState.get_next_level_path())
