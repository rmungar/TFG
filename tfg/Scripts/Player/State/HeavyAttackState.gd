class_name HeavyAttackState extends State
@onready var idleState: IdleState = $"../IdleState"
@onready var runState: RunState = $"../RunState"
@onready var jumpState: JumpState = $"../JumpState"
@onready var fallState: FallState = $"../FallState"

func enter() -> void:
	var heavyAttackHitbox: Area2D = player.get_node("HeavyAttackHitbox")
	var normalAttackHitbox: Area2D = player.get_node("NormalAttackHitbox")
	normalAttackHitbox.monitoring = false
	heavyAttackHitbox.monitoring = true
	var heavyAttackCollisionShape: CollisionShape2D = heavyAttackHitbox.get_node("CollisionShape2D")
	var normalAttackCollisionShape: CollisionShape2D = normalAttackHitbox.get_node("CollisionShape2D")
	heavyAttackCollisionShape.disabled = false
	normalAttackCollisionShape.disabled = true
	player.velocity.x = 0
	player.animationPlayer.play("HeavyAttack")
	await player.animationPlayer.animation_finished
	await get_tree().create_timer(0.1).timeout
	heavyAttackHitbox.monitoring = false
	heavyAttackCollisionShape.disabled = true

# What happens whenever our character leaves a state
func exit() -> void:
	pass
	

# Function called EVERY frame during _process
func process(delta: float) -> State:
	if player.animationPlayer.is_playing():
		return
	else:
		if player.facingDirection != 0:
			return runState
		else:
			return idleState
	if not player.is_on_floor():
		return fallState
	return null
	

# Function called EVERY frame during _physics_process
func physics(delta: float) -> State:
	return null


# Called when an input event occurs
func unhandledInput(event: InputEvent) -> State:
	if event.is_action_pressed("Jump") and player.is_on_floor():
		return jumpState
	else: 
		return null
