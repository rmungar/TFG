class_name IdleState extends State

@onready var RUN_STATE: RunState = $"../RunState"
@onready var JUMP_STATE: JumpState = $"../JumpState"
@onready var FALL_STATE: FallState = $"../FallState"
@onready var ATTACK_STATE: AttackState = $"../AttackState"


# What happens whenever our character enters the state
func enter() -> void:
	PLAYER.velocity.x = 0
	PLAYER.ANIMATION_PLAYER.play("Idle")	

# What happens whenever our character leaves a state
func exit() -> void:
	pass
	

# Function called EVERY frame during _process
func process(delta: float) -> State:
	if PLAYER.FACINGDIRECTION != 0:
		return RUN_STATE
	return null
	

# Function called EVERY frame during _physics_process
func physics(delta: float) -> State:
	if not PLAYER.is_on_floor():
		return FALL_STATE
	return null
	


# Called when an input event occurs
func unhandledInput(event: InputEvent) -> State:
	if event.is_action_pressed("Jump") and PLAYER.is_on_floor():
		return JUMP_STATE
	if event.is_action_pressed("Attack") and PLAYER.is_on_floor():
		return ATTACK_STATE
	return null
