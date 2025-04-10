class_name AerialAttackState extends State

@onready var IDLE_STATE: IdleState = $"../IdleState"
@onready var RUN_STATE: RunState = $"../RunState"
@onready var FALL_STATE: FallState = $"../FallState"
@onready var JUMP_STATE: JumpState = $"../JumpState"

# What happens whenever our character enters the state
func enter() -> void:
	PLAYER.ANIMATION_PLAYER.play("Attack")
	await PLAYER.ANIMATION_PLAYER.animation_finished

# What happens whenever our character leaves a state
func exit() -> void:
	pass

# Function called EVERY frame during _process
func process(delta: float) -> State:
	return null
	

# Function called EVERY frame during _physics_process
func physics(delta: float) -> State:
	
	if PLAYER.is_on_floor():
		return IDLE_STATE if PLAYER.FACINGDIRECTION == 0 else RUN_STATE
	else:
		return FALL_STATE if PLAYER.velocity.y > 0 else null
	return null
	


# Called when an input event occurs
func unhandledInput(event: InputEvent) -> State:
	return null
