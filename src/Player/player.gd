extends CharacterBody2D

# Movement settings
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Combat settings
const STAMINA_REGEN_RATE = 1.0
const STAMINA_ON_HIT = 2.0
const ATTACK_COST = 5.0
const ATTACK_AREA_OFFSET_X = 32

# Nodes
@onready var anim = $PlayerAnimation
@onready var sprite = $PlayerAnimatedSprite
@onready var stamina_bar = $Camera2D/StaminaBarUI
@onready var attack_area = $AttackArea
@onready var health_bar = $"../HealthBarUI"

# States
var is_attacking = false
var is_jumping = false
var is_hurt = false
var take_self_damage = false

func _ready() -> void:
	PlayerStats.health = PlayerStats.base_health
	PlayerStats.stamina = PlayerStats.base_stamina
	anim.animation_finished.connect(_on_animation_finished)

func _process(delta: float) -> void:
	regenerate_stamina(delta)

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_movement()
	handle_attack()
	move_and_slide()
	
func apply_gravity(delta: float) -> void:
	var was_jumping = not is_on_floor()
	
	if was_jumping:
		velocity += get_gravity() * delta
	
	if was_jumping and is_on_floor():
		is_jumping = false
			
func handle_movement() -> void:
	if is_attacking or is_hurt:
		return
		
	var direction := Input.get_axis("ui_left", "ui_right")
	handle_horizontal_movement(direction)
	handle_jump()
	handle_movement_animation(direction)

func handle_horizontal_movement(direction: float) -> void:
	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
		attack_area.position.x = ATTACK_AREA_OFFSET_X * (-1 if sprite.flip_h else 1)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
func handle_jump() -> void:
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
		
func handle_movement_animation(direction: float) -> void:
	if direction != 0 or not is_on_floor():
		anim.play("Run")
	else:
		anim.play("Idle")

func handle_attack() -> void:
	if Input.is_action_just_pressed("ui_accept") and can_attack():
		consume_stamina(ATTACK_COST)
		is_attacking = true
		perform_attack()

func perform_attack() -> void:
	anim.play("Attack")
	var hit = false
	for body in attack_area.get_overlapping_bodies():
		if body.has_method("take_damage"):
			body.take_damage(PlayerStats.attack)
			# Reward for landing a precise hit
			PlayerStats.stamina = min(PlayerStats.stamina + STAMINA_ON_HIT, PlayerStats.base_stamina)
			stamina_bar.update_stamina(PlayerStats.stamina, PlayerStats.base_stamina)
			hit = true
			return
	# Real samurai needs to be precise
	if not hit:
		take_self_damage = true

func can_attack() -> bool:
	return (PlayerStats.stamina >= ATTACK_COST) and not is_attacking

func consume_stamina(amount: float) -> void:
	PlayerStats.stamina = max(PlayerStats.stamina - amount, 0)
	stamina_bar.update_stamina(PlayerStats.stamina, PlayerStats.base_stamina)

func regenerate_stamina(delta: float) -> void:
	if not is_attacking and PlayerStats.stamina < PlayerStats.base_stamina:
		PlayerStats.stamina = min(PlayerStats.stamina + STAMINA_REGEN_RATE * delta, PlayerStats.base_stamina)
		stamina_bar.update_stamina(PlayerStats.stamina, PlayerStats.base_stamina)

func _on_animation_finished(anim_name) -> void:
	match anim_name:
		"Attack":
			is_attacking = false
			is_hurt = false
			if take_self_damage:
				take_self_damage = false
				lose_health(PlayerStats.attack)
		"Hurt":
			is_hurt = false
			is_attacking = false

func lose_health(amount: float) -> void:
	if is_hurt or is_attacking:
		return
		
	PlayerStats.health = max(PlayerStats.health - amount, 0)
	health_bar.update_health(PlayerStats.health, PlayerStats.base_health)
	
	if PlayerStats.health <= 0:
		die()
	else:
		is_hurt = true
		anim.play("Hurt")
		
func die() -> void:
	PlayerStats.reset()
	call_deferred("_change_scene")
	
func _change_scene() -> void:
	get_tree().reload_current_scene()
