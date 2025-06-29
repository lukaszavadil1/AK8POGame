extends CharacterBody2D

# Movement settings
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Stamina settings
const MAX_STAMINA = 16
const STAMINA_REGEN_RATE = 1.0
const ATTACK_COST = 5.0

# Nodes
@onready var player_animation = $PlayerAnimation
@onready var player_sprite = $PlayerAnimatedSprite
@onready var stamina_bar = $Camera2D/StaminaBarUI

# States
var current_stamina = MAX_STAMINA
var is_attacking = false
var is_jumping = false

func _ready() -> void:
	player_animation.animation_finished.connect(_on_animation_finished)
	stamina_bar.update_stamina(current_stamina, MAX_STAMINA)

func _process(delta: float) -> void:
	regenerate_stamina(delta)

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_movement()
	handle_attack()
	move_and_slide()
			
func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
func handle_movement() -> void:
	if is_attacking:
		return
		
	var direction := Input.get_axis("ui_left", "ui_right")
	handle_horizontal_movement(direction)
	handle_jump()
	update_movement_animation(direction)

func handle_horizontal_movement(direction: float) -> void:
	if direction:
		velocity.x = direction * SPEED
		player_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
func handle_jump() -> void:
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
		
func update_movement_animation(direction: float) -> void:
	if direction != 0:
		player_animation.play("Run")
	elif is_on_floor():
		player_animation.play("Idle")
	else:
		player_animation.play("Jump")
		
func handle_attack() -> void:
	if Input.is_action_just_pressed("ui_accept") and can_attack() and not is_attacking:
		consume_stamina(ATTACK_COST)
		is_attacking = true
		player_animation.play("Attack")

func can_attack() -> bool:
	return current_stamina >= ATTACK_COST

func consume_stamina(amount: float) -> void:
	current_stamina = max(current_stamina - amount, 0)
	stamina_bar.update_stamina(current_stamina, MAX_STAMINA)

func regenerate_stamina(delta: float) -> void:
	if not is_attacking and current_stamina < MAX_STAMINA:
		current_stamina = min(current_stamina + STAMINA_REGEN_RATE * delta, MAX_STAMINA)
		stamina_bar.update_stamina(current_stamina, MAX_STAMINA)

func _on_animation_finished(anim_name) -> void:
	match anim_name:
		"Attack":
			is_attacking = false
		"Jump":
			is_jumping = false
			
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if (event.keycode == KEY_Q or event.keycode == KEY_ESCAPE) and event.pressed:
			quit_game()
			
func quit_game() -> void:
	get_tree().quit()
