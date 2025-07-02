extends CharacterBody2D

@export var max_health: int = 50
@export var points_on_death: int = 2
var current_health: int
var is_dead = false
const GRAVITY = 1200.0 

@onready var enemy_animation = $Enemy1Sprite2D
@onready var sprite = $Enemy1Sprite2D
@onready var health_bar = $HealthBar

func _ready() -> void:
	current_health = max_health
	update_health_bar()
	enemy_animation.play("Idle")
	enemy_animation.animation_finished.connect(_on_animation_finished)

func _on_animation_finished() -> void:
	if enemy_animation.animation == "Hurt" and not is_dead:
		enemy_animation.play("Idle")

func take_damage(amount: int) -> void:
	if is_dead:
		return

	current_health -= amount
	update_health_bar()

	if current_health <= 0:
		die()
	else:
		enemy_animation.play("Hurt")

func update_health_bar() -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health

func _physics_process(delta: float) -> void:
	if not is_dead:
		apply_gravity(delta)
		move_and_slide()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0

func die() -> void:
	is_dead = true
	enemy_animation.play("Death")
	await enemy_animation.animation_finished
	PlayerStats.add_points(points_on_death)
	queue_free()
