class_name JumpState extends State

@onready var fallState: FallState = $"../FallState"
@onready var aerialAttackState: AerialAttackState = $"../AerialAttackState"

# What happens whenever our character enters the state
func enter() -> void:
	if player.facingDirection == 0:
		player.velocity.x = 0
	player.velocity.y = player.jumpStrength
	player.animationPlayer.play("Jump")

# What happens whenever our character leaves a state
func exit() -> void:
	pass
	

# Function called EVERY frame during _process
func process(delta: float) -> State:
	if Input.is_action_just_pressed("Attack"):
		return aerialAttackState
	return null
	

# Function called EVERY frame during _physics_process
func physics(delta: float) -> State:
	if player.facingDirection != 0:
		player.velocity.x = lerp(player.velocity.x, - player.facingDirection * player.airSpeed, player.airAcceleration)
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, player.airAcceleration * 0.5)
	
	if player.velocity.y >= 0:
		return fallState
	return null
	


# Called when an input event occurs
func unhandledInput(event: InputEvent) -> State:
	return null
