class_name HealingState extends State

@onready var runState: RunState = $"../RunState"
@onready var jumpState: JumpState = $"../JumpState"
@onready var fallState: FallState = $"../FallState"
@onready var attackState: AttackState = $"../AttackState"
@onready var idleState: IdleState = $"../IdleState"
@onready var interactingState: Node = $"../InteractingState"
@onready var healingState: HealingState = $"."



# What happens whenever our character enters the state
func enter() -> void:
	player.velocity.x = 0
	var healingEffect: AnimatedSprite2D = player.get_node("HealingEffect")
	healingEffect.play("default")

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
	if event.is_action_pressed("Jump") and player.is_on_floor() and !GameManager.isDialogInScreen:
		return jumpState
	if event.is_action_pressed("Attack") and player.is_on_floor():
		return attackState
	if event.is_action_pressed("Heal"):
		return healingState
	return null
