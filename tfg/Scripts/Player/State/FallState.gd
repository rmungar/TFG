class_name FallState extends State

@onready var idleState: IdleState = $"../IdleState"
@onready var runState: RunState = $"../RunState"
@onready var attackState: AttackState = $"../AttackState"

# What happens whenever our character enters the state
func enter() -> void:
	player.animationPlayer.play("Fall")	

# What happens whenever our character leaves a state
func exit() -> void:
	pass
	

# Function called EVERY frame during _process
func process(delta: float) -> State:
	return null
	

# Function called EVERY frame during _physics_process
func physics(delta: float) -> State:
	
	if player.FACINGDIRECTION != 0:
		player.velocity.x = lerp(player.velocity.x, - player.FACINGDIRECTION * player.AIR_SPEED, player.AIR_ACCELERATION)
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, player.AIR_ACCELERATION * 0.5)
	
	if player.is_on_floor():
		return idleState if player.FACINGDIRECTION == 0 else runState
	return null


# Called when an input event occurs
func unhandledInput(event: InputEvent) -> State:
	if event.is_action_pressed("Attack"):
		return attackState
	return null
