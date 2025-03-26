class_name Player extends CharacterBody2D

@onready var SPRITE: Sprite2D = $Sprite2D
@onready var ANIMATION_PLAYER: AnimationPlayer = $AnimationPlayer

@export var SPEED: float = 200.0
@export var AIR_SPEED: float = -150.0
@export var AIR_ACCELERATION: float = 0.1
@export var JUMP_STRENGTH: float = -350.0
@export var GRAVITY: float = 980.0
@export var DELECERATION: float = 0.2
var FACINGDIRECTION: float

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	handleMovement(delta)
	updateAnimations()
	move_and_slide()

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func handleMovement(delta: float) -> void:
	# Handle directions
	FACINGDIRECTION = 0.0
	if Input.is_action_pressed("MoveLeft"):
		FACINGDIRECTION = -1.0	
	elif Input.is_action_pressed("MoveRight"):
		FACINGDIRECTION = 1.0
	if FACINGDIRECTION != 0:
		SPRITE.flip_h = FACINGDIRECTION < 0
	if FACINGDIRECTION != 0:
		velocity.x = FACINGDIRECTION * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * DELECERATION)
	
func updateAnimations() -> void:
	if not is_on_floor():
		if velocity.y < 0:
			ANIMATION_PLAYER.play("Jump")
		else:
			ANIMATION_PLAYER.play("Fall")
	else:
		if velocity.x != 0:
			ANIMATION_PLAYER.play("Run")
		else:
			ANIMATION_PLAYER.play("Idle")
