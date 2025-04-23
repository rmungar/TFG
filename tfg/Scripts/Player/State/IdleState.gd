class_name IdleState extends State

@onready var runState: RunState = $"../RunState"
@onready var jumpState: JumpState = $"../JumpState"
@onready var fallState: FallState = $"../FallState"
@onready var attackState: AttackState = $"../AttackState"


# What happens whenever our character enters the state
func enter() -> void:
	player.velocity.x = 0
	player.animationPlayer.play("Idle")	

# What happens whenever our character leaves a state
func exit() -> void:
	pass
	

# Function called EVERY frame during _process
func process(delta: float) -> State:
	if player.facingDirection != 0:
		return runState
	return null
	

# Function called EVERY frame during _physics_process
func physics(delta: float) -> State:
	if not player.is_on_floor():
		return fallState
	return null
	


# Called when an input event occurs
func unhandledInput(event: InputEvent) -> State:
	if event.is_action_pressed("Jump") and player.is_on_floor():
		return jumpState
	if event.is_action_pressed("Attack") and player.is_on_floor():
		return attackState
	return null
