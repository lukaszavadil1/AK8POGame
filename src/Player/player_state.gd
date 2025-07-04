extends Node

enum State {
	IDLE,
	MOVING,
	JUMPING,
	ATTACKING,
	HURT,
	DEAD
}

# Core stats
var health: float = 100.0
var base_health: float = 100.0
var stamina: float = 16.0
var base_stamina: float = 16.0
var attack: float = 10.0
var current_state: State = State.IDLE
var previous_state: State = State.IDLE

# Progression stats
var upgrade_points: int = 0
var kill_count: int = 0

# Constants
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const STAMINA_REGEN_RATE = 1.0
const STAMINA_ON_HIT = 2.0
const ATTACK_COST = 5.0
const ATTACK_AREA_OFFSET_X = 32

func reset():
	base_health = 100.0
	health = base_health
	base_stamina = 16.0
	stamina = base_stamina
	attack = 10.0
	upgrade_points = 0
	kill_count = 0
	current_state = State.IDLE
	previous_state = State.IDLE
	
func respawn():
	health = base_health
	stamina = base_stamina
	current_state = State.IDLE
	previous_state = State.IDLE
	upgrade_points = 0

func add_points(points: int) -> void:
	upgrade_points += points

func consume_stamina(amount: float) -> void:
	stamina = max(stamina - amount, 0)
	
func regenerate_stamina(delta: float) -> void:
	stamina = min(stamina + STAMINA_REGEN_RATE * delta, base_stamina)

func add_kill() -> void:
	kill_count += 1
	
func change_state(new_state: State) -> void:
	if current_state == State.DEAD:
		return

	previous_state = current_state
	current_state = new_state

func is_state(state: State) -> bool:
	return current_state == state

func is_invulnerable() -> bool:
	return current_state in [State.HURT, State.ATTACKING, State.DEAD]
