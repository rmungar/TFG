class_name State extends Node

static var player: Player
static var stateMachine: StateMachine	

# What happens whenever our character enters the state
func enter() -> void:
	pass
	

# What happens whenever our character leaves a state
func exit() -> void:
	pass
	

# Function called EVERY frame during _process
func process(delta: float) -> State:
	return null
	

# Function called EVERY frame during _physics_process
func physics(delta: float) -> State:
	return null
	


# Called when an input event occurs
func unhandledInput(_event: InputEvent) -> State:
	return null
