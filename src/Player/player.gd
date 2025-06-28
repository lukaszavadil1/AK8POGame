extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var anim = $PlayerAnimation
var is_attacking = false

func _ready():
	anim.connect("animation_finished", _on_animation_finished)
	
func _on_animation_finished(anim_name):
	if anim_name == "Attack":
		is_attacking = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle attack
	if Input.is_action_pressed("ui_accept"):
		is_attacking = true
		anim.play("Attack")
	
	if not is_attacking:
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction == -1:
			get_node("PlayerAnimatedSprite").flip_h = true
		elif direction == 1:
			get_node("PlayerAnimatedSprite").flip_h = false
		if direction:
			velocity.x = direction * SPEED
			anim.play("Run")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			anim.play("Idle")

	move_and_slide()
