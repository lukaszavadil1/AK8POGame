extends CharacterBody2D

# Nodes
@onready var anim = $PlayerAnimation
@onready var sprite = $PlayerAnimatedSprite
@onready var stamina_bar = $Camera2D/StaminaBarUI
@onready var attack_area = $AttackArea
@onready var health_bar = $"../HealthBarUI"

var take_self_damage = false

func _ready() -> void:
	anim.animation_finished.connect(_on_animation_finished)

func _process(delta: float) -> void:
	PlayerState.regenerate_stamina(delta)
	stamina_bar.update_stamina(PlayerState.stamina, PlayerState.base_stamina)

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_movement()
	handle_attack()
	move_and_slide()
	
func apply_gravity(delta: float) -> void:
	var was_jumping = not is_on_floor()
	
	if was_jumping:
		velocity += get_gravity() * delta
	
	if was_jumping and is_on_floor() and PlayerState.is_state(PlayerState.State.JUMPING):
		PlayerState.change_state(PlayerState.State.IDLE)
			
func handle_movement() -> void:
	if PlayerState.is_invulnerable() and not PlayerState.is_state(PlayerState.State.JUMPING):
		return
		
	var direction := Input.get_axis("ui_left", "ui_right")
	handle_horizontal_movement(direction)
	handle_jump()
	handle_movement_animation(direction)

func handle_horizontal_movement(direction: float) -> void:
	if direction:
		velocity.x = direction * PlayerState.SPEED
		sprite.flip_h = direction < 0
		attack_area.position.x = PlayerState.ATTACK_AREA_OFFSET_X * (-1 if sprite.flip_h else 1)
	else:
		velocity.x = move_toward(velocity.x, 0, PlayerState.SPEED)
		
func handle_jump() -> void:
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = PlayerState.JUMP_VELOCITY
		PlayerState.change_state(PlayerState.State.JUMPING)
		
func handle_movement_animation(direction: float) -> void:
	if direction != 0 or not is_on_floor():
		if not PlayerState.is_state(PlayerState.State.MOVING):
			PlayerState.change_state(PlayerState.State.MOVING)
		if not anim.current_animation == "Run":
			anim.play("Run")
	else:
		if not PlayerState.is_state(PlayerState.State.IDLE):
			PlayerState.change_state(PlayerState.State.IDLE)
		if not anim.current_animation == "Idle":
			anim.play("Idle")

func handle_attack() -> void:
	if Input.is_action_just_pressed("ui_accept") and can_attack():
		PlayerState.consume_stamina(PlayerState.ATTACK_COST)
		PlayerState.change_state(PlayerState.State.ATTACKING)
		perform_attack()

func perform_attack() -> void:
	anim.play("Attack")
	var hit = false
	for body in attack_area.get_overlapping_bodies():
		if body.has_method("take_damage"):
			body.take_damage(PlayerState.attack)
			# Reward for landing a precise hit
			PlayerState.stamina = min(PlayerState.stamina + PlayerState.STAMINA_ON_HIT, PlayerState.base_stamina)
			stamina_bar.update_stamina(PlayerState.stamina, PlayerState.base_stamina)
			hit = true
			return
	# Real samurai needs to be precise
	if not hit:
		take_self_damage = true

func can_attack() -> bool:
	return (PlayerState.stamina >= PlayerState.ATTACK_COST) and not PlayerState.is_state(PlayerState.State.ATTACKING)

func _on_animation_finished(anim_name) -> void:
	match anim_name:
		"Attack":
			if take_self_damage:
				take_self_damage = false
				lose_health(PlayerState.attack)
				
			var direction = Input.get_axis("ui_left", "ui_right")
			if direction != 0:
				PlayerState.change_state(PlayerState.State.MOVING)
				anim.play("Run")
			else:
				PlayerState.change_state(PlayerState.State.IDLE)
				anim.play("Idle")
				
		"Hurt":
			var direction = Input.get_axis("ui_left", "ui_right")
			if direction != 0:
				PlayerState.change_state(PlayerState.State.MOVING)
				anim.play("Run")
			else:
				PlayerState.change_state(PlayerState.State.IDLE)
				anim.play("Idle")

func lose_health(amount: float) -> void:
	PlayerState.health = max(PlayerState.health - amount, 0)
	health_bar.update_health(PlayerState.health, PlayerState.base_health)
	
	if PlayerState.health <= 0:
		die()
	else:
		PlayerState.change_state(PlayerState.State.HURT)
		anim.play("Hurt")
		
func die() -> void:
	await get_tree().process_frame
	get_tree().reload_current_scene()
