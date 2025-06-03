class_name AttackState extends State

@onready var idleState: IdleState = $"../IdleState"
@onready var runState: RunState = $"../RunState"
@onready var jumpState: JumpState = $"../JumpState"
@onready var fallState: FallState = $"../FallState"
@onready var heavyAttackState: HeavyAttackState = $"../HeavyAttackState"

func enter() -> void:
	var normalAttackHitbox = player.get_node("NormalAttackHitbox")
	normalAttackHitbox.monitoring = true
	var normalAttackCollisionShape: CollisionShape2D = normalAttackHitbox.get_node("CollisionShape2D")
	normalAttackCollisionShape.disabled = false
	
	player.velocity.x = 0
	player.animationPlayer.play("Attack")
	
	await player.animationPlayer.animation_finished
	await get_tree().create_timer(0.2).timeout 
	
	normalAttackHitbox.monitoring = false
	normalAttackCollisionShape.disabled = true

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
	if Input.is_action_pressed("Jump") and player.is_on_floor() and !GameManager.isDialogInScreen:
		return jumpState
	elif Input.is_action_just_pressed("Attack") and !GameManager.isDialogInScreen and player.canAttack:
			return heavyAttackState
	else: 
		return null
