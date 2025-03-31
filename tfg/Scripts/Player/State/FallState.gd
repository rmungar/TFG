class_name FallState extends State

@onready var IDLE_STATE: IdleState = $"../IdleState"
@onready var RUN_STATE: RunState = $"../RunState"
@onready var ATTACK_STATE: AttackState = $"../AttackState"

# What happens whenever our character enters the state
func enter() -> void:
	PLAYER.ANIMATION_PLAYER.play("Fall")	

# What happens whenever our character leaves a state
func exit() -> void:
	pass
	

# Function called EVERY frame during _process
func process(delta: float) -> State:
	return null
	

# Function called EVERY frame during _physics_process
func physics(delta: float) -> State:
	
	if PLAYER.FACINGDIRECTION != 0:
		PLAYER.velocity.x = lerp(PLAYER.velocity.x, - PLAYER.FACINGDIRECTION * PLAYER.AIR_SPEED, PLAYER.AIR_ACCELERATION)
	else:
		PLAYER.velocity.x = lerp(PLAYER.velocity.x, 0.0, PLAYER.AIR_ACCELERATION * 0.5)
	
	if PLAYER.is_on_floor():
		return IDLE_STATE if PLAYER.FACINGDIRECTION == 0 else RUN_STATE
	return null


# Called when an input event occurs
func unhandledInput(event: InputEvent) -> State:
	if event.is_action_pressed("Attack"):
		return ATTACK_STATE
	return null
