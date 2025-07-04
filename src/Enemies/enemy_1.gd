extends CharacterBody2D

@export var max_health: int = 50
@export var points_on_death: int = 2
var current_health: int
var is_dead = false
const GRAVITY = 1200.0 

@onready var enemy_animation = $Enemy1Sprite2D
@onready var sprite = $Enemy1Sprite2D
@onready var health_bar = $HealthBar
@onready var attack_area = $AttackAreaEnemy

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
var is_attacking: bool = false 
var facing_direction: int = 1

@onready var player: Node2D

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
	
	attack_area.position = Vector2(0, 0)

func _on_animation_finished() -> void:
	if enemy_animation.animation == "Hurt" and not is_dead:
		enemy_animation.play("Idle")
	elif enemy_animation.animation == "Attack_1" and not is_dead:
		is_attacking = false  # Attack finished
		enemy_animation.play("Idle")
	elif enemy_animation.animation == "Death":
		# Death animation finished, handled in die()
		pass

func take_damage(amount: int) -> void:
	if is_dead:
		return
	current_health -= amount
	update_health_bar()
	if current_health <= 0:
		die()
	else:
		# Only play hurt animation if not currently attacking
		if not is_attacking:
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
	
	# Calculate facing direction
	var dir = sign(player.global_position.x - global_position.x)
	if dir != 0:
		facing_direction = dir
	
	if distance <= attack_range and not is_attacking:
		# Stop moving and attack
		velocity.x = 0
		if attack_timer <= 0.0:
			start_attack()
			attack_timer = attack_cooldown
		else:
			# Wait for attack cooldown
			if enemy_animation.animation != "Attack_1":
				enemy_animation.play("Idle")
	elif distance <= chase_range and not is_attacking:
		# Chase the player
		velocity.x = facing_direction * speed
		sprite.flip_h = facing_direction < 0
		if enemy_animation.animation != "Walk":
			enemy_animation.play("Walk")
	elif not is_attacking:
		# Patrol when player is far away
		patrol()

func patrol() -> void:
	var dir = sign(patrol_target.x - global_position.x)
	velocity.x = dir * speed * 0.5
	sprite.flip_h = dir < 0
	facing_direction = dir if dir != 0 else facing_direction
	
	if enemy_animation.animation != "Walk":
		enemy_animation.play("Walk")
	
	if global_position.distance_to(patrol_target) < 10:
		var temp = patrol_origin
		patrol_origin = patrol_target
		patrol_target = temp

func start_attack() -> void:
	is_attacking = true
	has_damaged = false
	velocity.x = 0  # Stop movement during attack
	
	# Set sprite direction
	sprite.flip_h = facing_direction < 0
	
	enemy_animation.play("Attack_1")
	
	# Wait for the attack animation to reach the "impact" frame
	await get_tree().create_timer(0.6).timeout
	
	var attack_distance = 40.0
	if(facing_direction == 1):
		attack_distance = 30.0
	attack_area.position.x = attack_distance * facing_direction
	
	if is_attacking and not is_dead:
		attack_area.monitoring = true
		await get_tree().create_timer(0.1).timeout
		attack_area.monitoring = false

func _on_attack_area_enemy_body_entered(body: Node2D) -> void:
	if is_dead or has_damaged or not is_attacking:
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
	is_attacking = false
	velocity.x = 0
	attack_area.monitoring = false
	enemy_animation.play("Death")
	await enemy_animation.animation_finished
	PlayerState.add_points(points_on_death)
	PlayerState.kill_count += 1
	queue_free()
