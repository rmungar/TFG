class_name AttackState extends State

@onready var idleState: IdleState = $"../IdleState"
@onready var runState: RunState = $"../RunState"
@onready var jumpState: JumpState = $"../JumpState"
@onready var fallState: FallState = $"../FallState"
@onready var heavyAttackState: HeavyAttackState = $"../HeavyAttackState"

func enter() -> void:
	var normalAttackHitbox = player.get_node("NormalAttackHitbox")
	normalAttackHitbox.monitoring = true
	normalAttackHitbox.get_child(0).disabled = false
	player.velocity.x = 0
	player.animationPlayer.play("Attack")
	normalAttackHitbox.monitoring = false
	normalAttackHitbox.get_child(0).disabled = true

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
	elif Input.is_action_just_pressed("Attack"):
			return heavyAttackState
	else: 
		return null
