class_name HeavyAttackState extends State
@onready var IDLE_STATE: IdleState = $"../IdleState"
@onready var RUN_STATE: RunState = $"../RunState"
@onready var JUMP_STATE: JumpState = $"../JumpState"
@onready var FALL_STATE: FallState = $"../FallState"

func enter() -> void:
	PLAYER.velocity.x = 0
	PLAYER.ANIMATION_PLAYER.play("HeavyAttack")
	await PLAYER.ANIMATION_PLAYER.animation_finished

# What happens whenever our character leaves a state
func exit() -> void:
	pass
	

# Function called EVERY frame during _process
func process(delta: float) -> State:
	if PLAYER.ANIMATION_PLAYER.is_playing():
		return
	else:
		if PLAYER.FACINGDIRECTION != 0:
			return RUN_STATE
		else:
			return IDLE_STATE
	if not PLAYER.is_on_floor():
		return FALL_STATE
	return null
	

# Function called EVERY frame during _physics_process
func physics(delta: float) -> State:
	return null


# Called when an input event occurs
func unhandledInput(event: InputEvent) -> State:
	if event.is_action_pressed("Jump") and PLAYER.is_on_floor():
		return JUMP_STATE
	else: 
		return null
