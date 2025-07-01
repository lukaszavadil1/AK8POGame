extends CanvasLayer


@onready var upgrade_points_label = $UpgradePoints
@onready var health_label = $Health
@onready var attack_label = $Attack
@onready var stamina_label = $Stamina
@onready var upgrade_health_button = $UpgradeHealth
@onready var upgrade_attack_button = $UpgradeAttack
@onready var upgrade_stamina_button = $UpgradeStamina

func _ready():
	update_ui()

func update_ui():
	upgrade_points_label.text = "Upgrade Points left: %d" % PlayerStats.upgrade_points
	health_label.text = "Health: %d" % PlayerStats.base_health
	attack_label.text = "Attack: %d" % PlayerStats.attack
	stamina_label.text = "Stamina: %d" % PlayerStats.base_stamina
	
	var can_upgrade = PlayerStats.upgrade_points > 0
	upgrade_health_button.disabled = not can_upgrade
	upgrade_attack_button.disabled = not can_upgrade
	upgrade_stamina_button.disabled = not can_upgrade


func _on_upgrade_health_pressed() -> void:
	if PlayerStats.upgrade_points > 0:
		PlayerStats.base_health += 10
		PlayerStats.health = PlayerStats.base_health
		PlayerStats.upgrade_points -= 1
		update_ui()


func _on_upgrade_stamina_pressed() -> void:
	if PlayerStats.upgrade_points > 0:
		PlayerStats.base_stamina += 5
		PlayerStats.stamina = PlayerStats.base_stamina
		PlayerStats.upgrade_points -= 1
		update_ui()


func _on_upgrade_attack_pressed() -> void:
	if PlayerStats.upgrade_points > 0:
		PlayerStats.attack += 2
		PlayerStats.upgrade_points -= 1
		update_ui()


func _on_back_to_menu_pressed() -> void:
	PlayerStats.reset()
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")


func _on_next_level_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")
