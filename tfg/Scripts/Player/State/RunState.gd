class_name RunState extends State

@onready var idleState: IdleState = $"../IdleState"
@onready var jumpState: JumpState = $"../JumpState"
@onready var fallState: FallState = $"../FallState"
@onready var attackState: AttackState = $"../AttackState"

var runSound: AudioStreamPlayer  # Referencia al sonido de correr

func enter() -> void:
	player.animationPlayer.play("Run")
	# Solo reproducir si no se está ya reproduciendo
	AudioManager.play_tagged_sound("run", "res://Assets/Sounds/run.mp3", -40.0)
func exit() -> void:
	# Detener solo el sonido de correr
	AudioManager.stop_tagged_sound("run")

func process(delta: float) -> State:
	if player.facingDirection == 0:
		if player.is_on_floor():
			return idleState
		else:
			return fallState
	return null

func physics(delta: float) -> State:
	player.velocity.x = player.facingDirection * player.speed
	if not player.is_on_floor():
		return fallState
	return null

func unhandledInput(event: InputEvent) -> State:
	if Input.is_action_pressed("Jump") and player.is_on_floor() and not GameManager.isDialogInScreen:
		return jumpState
	if Input.is_action_pressed("Attack") and player.is_on_floor() and not GameManager.isDialogInScreen and player.canAttack:
		return attackState
	return null
