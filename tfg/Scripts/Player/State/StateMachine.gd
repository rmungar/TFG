class_name StateMachine extends Node

var STATES: Array[State] = []
var CURRENT_STATE: State
var PREVIOUS_STATE: State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	changeState(CURRENT_STATE.process(delta))


func _physics_process(delta: float) -> void:
	changeState(CURRENT_STATE.physics(delta))

func _unhandled_input(event: InputEvent) -> void:
	changeState(CURRENT_STATE.unhandledInput(event))

func configure(player: Player) -> void:
	
	for child in get_children():
		if child is State:
			STATES.append(child)
	if not STATES:
		return
	
	STATES[0].PLAYER = player
	STATES[0].STATE_MACHINE = self
	
	changeState(STATES[0])
	process_mode = Node.PROCESS_MODE_INHERIT


func changeState(newState: State) -> void:
	if newState == null or newState == CURRENT_STATE:
		return
	if CURRENT_STATE:
		CURRENT_STATE.exit()
		
	PREVIOUS_STATE = CURRENT_STATE
	CURRENT_STATE= newState
	CURRENT_STATE.enter()
	
