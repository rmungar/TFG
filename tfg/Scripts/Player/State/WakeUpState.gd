class_name WakeUpState extends State

@onready var idleState: IdleState = $"../IdleState"

signal WokenUp()


# Llamado al entrar en el estado
func enter() -> void:
	player.canMove = false
	
	player.animationPlayer.play("WakeUp")
	await get_tree().create_timer(0.9).timeout
	AudioManager.play_sound("res://Assets/Sounds/playerWakeUp.wav", -40.0)
	await player.animationPlayer.animation_finished
	player.shouldWakeUp = false
	if player.lastCheckPoint == Vector2(0.0, 0.0):
		WokenUp.emit()
	else:
		pass

# Llamado al salir del estado
func exit() -> void:
	pass

# Mientras está en el estado (cada frame en _process)
func process(delta: float) -> State:
	# Cuando termine la animación, volver al estado Idle
	if not player.animationPlayer.is_playing():
		return idleState
	return null

# Cada frame en _physics_process
func physics(delta: float) -> State:
	return null

# Eventos de input, se ignoran mientras despierta
func unhandledInput(event: InputEvent) -> State:
	return null
