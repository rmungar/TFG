class_name AerialAttackState extends State

@onready var idleState: IdleState = $"../IdleState"
@onready var runState: RunState = $"../RunState"
@onready var fallState: FallState = $"../FallState"
@onready var jumpState: JumpState = $"../JumpState"

# What happens whenever our character enters the state
func enter() -> void:
	
	var normalAttackHitbox = player.get_node("NormalAttackHitbox")
	normalAttackHitbox.monitoring = true
	var normalAttackCollisionShape: CollisionShape2D = normalAttackHitbox.get_node("CollisionShape2D")
	normalAttackCollisionShape.disabled = false
	
	player.velocity.x *= 0.7
	AudioManager.play_sound("res://Assets/Sounds/Sword Woosh B.wav", -40.0)
	player.animationPlayer.play("Attack")
	
	await player.animationPlayer.animation_finished
	
	normalAttackHitbox.monitoring = false
	normalAttackCollisionShape.disabled = true

# What happens whenever our character leaves a state
func exit() -> void:
	pass

# Function called EVERY frame during _process
func process(delta: float) -> State:
	return null
	

# Function called EVERY frame during _physics_process
func physics(delta: float) -> State:
	
	if player.is_on_floor():
		var normalAttackHitbox = player.get_node("NormalAttackHitbox")
		var normalAttackCollisionShape: CollisionShape2D = normalAttackHitbox.get_node("CollisionShape2D")
		normalAttackHitbox.monitoring = false
		normalAttackCollisionShape.disabled = true
		return idleState if player.facingDirection == 0 else runState
	else:
		return fallState if player.velocity.y > 0 else null


# Called when an input event occurs
func unhandledInput(event: InputEvent) -> State:
	return null
