class_name StateMachine extends Node

var states: Array[State] = []
var currentState: State
var previousState: State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	changeState(currentState.process(delta))


func _physics_process(delta: float) -> void:
	changeState(currentState.physics(delta))

func _unhandled_input(event: InputEvent) -> void:
	changeState(currentState.unhandledInput(event))

func configure(player: Player) -> void:
	
	for child in get_children():
		if child is State:
			states.append(child)
	if not states:
		return
		
	# Asignar player y stateMachine a cada estado
	for state in states:
		state.player = player
		state.stateMachine = self
		
	# Buscar el estado de WakeUp
	var wakeUpState: State = null
	for state in states:
		if state is WakeUpState:
			wakeUpState = state
			break
			
	# Decidir el estado inicial
	if player.shouldWakeUp and wakeUpState != null:
		changeState(wakeUpState)
	else:
		changeState(states[0]) # o busca IdleState si prefieres
		
	process_mode = Node.PROCESS_MODE_INHERIT


func changeState(newState: State) -> void:
	if newState == null or newState == currentState:
		return
	if currentState:
		currentState.exit()
		
	previousState = currentState
	currentState= newState
	currentState.enter()
	
