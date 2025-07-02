extends CharacterBody2D

@export var max_health: int = 50
@export var points_on_death: int = 2
var current_health: int
var is_dead = false
const GRAVITY = 1200.0 

@onready var enemy_animation = $Enemy1Sprite2D
@onready var sprite = $Enemy1Sprite2D
@onready var health_bar = $HealthBar

@export var speed: float = 80.0
@export var patrol_distance: float = 100.0
@export var chase_range: float = 200.0
@export var attack_range: float = 30.0
@export var attack_damage: int = 20
@export var attack_cooldown: float = 1.2

var patrol_origin: Vector2
var patrol_target: Vector2
var attack_timer: float = 0.0
var has_damaged: bool = false

@onready var player: Node2D
@onready var attack_area = $AttackAreaEnemy

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	current_health = max_health
	update_health_bar()
	enemy_animation.play("Idle")
	enemy_animation.animation_finished.connect(_on_animation_finished)

	patrol_origin = global_position
	patrol_target = patrol_origin + Vector2(patrol_distance, 0)
	attack_area.monitoring = false
	attack_area.connect("body_entered", Callable(self, "_on_attack_area_enemy_body_entered"))

func _on_animation_finished() -> void:
	if enemy_animation.animation == "Hurt" and not is_dead:
		enemy_animation.play("Idle")
	elif enemy_animation.animation == "Attack_1" and not is_dead:
		enemy_animation.play("Walk")

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
	if is_dead:
		return

	apply_gravity(delta)
	update_ai(delta)
	move_and_slide()

func update_ai(delta: float) -> void:
	if not player:
		return

	var distance = global_position.distance_to(player.global_position)
	attack_timer -= delta

	if distance <= attack_range:
		velocity.x = 0
		enemy_animation.play("Attack_1")
		if attack_timer <= 0.0:
			start_attack()
			attack_timer = attack_cooldown
	elif distance <= chase_range:
		var dir = sign(player.global_position.x - global_position.x)
		velocity.x = dir * speed
		sprite.flip_h = dir < 0
		attack_area.scale.x = dir
	else:
		patrol()
		
func patrol() -> void:
	var dir = sign(patrol_target.x - global_position.x)
	velocity.x = dir * speed * 0.5
	sprite.flip_h = dir < 0
	enemy_animation.play("Walk")

	if global_position.distance_to(patrol_target) < 10:
		var temp = patrol_origin
		patrol_origin = patrol_target
		patrol_target = temp
		
func start_attack() -> void:
	has_damaged = false
	attack_area.monitoring = true
	await get_tree().create_timer(0.2).timeout  # delay to sync with swing
	attack_area.monitoring = false

func _on_attack_area_enemy_body_entered(body: Node2D) -> void:
	if is_dead or has_damaged:
		return

	if body.is_in_group("Player") and body.has_method("lose_health"):
		body.lose_health(attack_damage)
		has_damaged = true
			
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
