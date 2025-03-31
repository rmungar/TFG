class_name JumpState extends State

@onready var FALL_STATE: FallState = $"../FallState"

# What happens whenever our character enters the state
func enter() -> void:
	if PLAYER.FACINGDIRECTION == 0:
		PLAYER.velocity.x = 0
	PLAYER.velocity.y = PLAYER.JUMP_STRENGTH
	PLAYER.ANIMATION_PLAYER.play("Jump")

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
	
	if PLAYER.velocity.y >= 0:
		return FALL_STATE
	return null
	


# Called when an input event occurs
func unhandledInput(event: InputEvent) -> State:
	return null
