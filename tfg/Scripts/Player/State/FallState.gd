class_name FallState extends State

@onready var idleState: IdleState = $"../IdleState"
@onready var runState: RunState = $"../RunState"
@onready var attackState: AttackState = $"../AttackState"

# What happens whenever our character enters the state
func enter() -> void:
	var normalAttackHitbox = player.get_node("NormalAttackHitbox")
	var normalAttackCollisionShape: CollisionShape2D = normalAttackHitbox.get_node("CollisionShape2D")
	normalAttackHitbox.monitoring = false
	normalAttackCollisionShape.disabled = true
	player.animationPlayer.play("Fall")	

# What happens whenever our character leaves a state
func exit() -> void:
	AudioManager.play_sound("res://Assets/Sounds/fall.mp3", -50.0)
	pass
	

# Function called EVERY frame during _process
func process(delta: float) -> State:
	return null
	

# Function called EVERY frame during _physics_process
func physics(delta: float) -> State:
	if player.facingDirection != 0:
		player.velocity.x = lerp(player.velocity.x, - player.facingDirection * player.airSpeed, player.airAcceleration)
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, player.airAcceleration * 0.5)
	
	if player.is_on_floor():
		return idleState if player.facingDirection == 0 else runState
	return null


# Called when an input event occurs
func unhandledInput(event: InputEvent) -> State:
	if Input.is_action_pressed("Attack") and !GameManager.isDialogInScreen and player.canAttack:
		return attackState
	return null
