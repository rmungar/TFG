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



func _process(delta: float) -> void:
	# Handle directions
	if Input.is_action_pressed("MoveLeft"):
		FACINGDIRECTION = -1.0	
	elif Input.is_action_pressed("MoveRight"):
		FACINGDIRECTION = 1.0
	

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		handleAirMovement(delta)
	else:
		handleGroundMovement(delta)
	handleJump()
	updateAnimations()
	move_and_slide()

	

func handleGroundMovement(delta: float) -> void:

	if FACINGDIRECTION != 0:
		SPRITE.flip_h = FACINGDIRECTION < 0
	if FACINGDIRECTION != 0 and (Input.is_action_pressed("MoveLeft") or Input.is_action_pressed("MoveRight")) :
		velocity.x = FACINGDIRECTION * SPEED
	else:
		velocity.x = 0.0

func handleAirMovement(delta: float) -> void:
	if FACINGDIRECTION:
		SPRITE.flip_h = FACINGDIRECTION < 0
		velocity.x = lerp(velocity.x, -FACINGDIRECTION * AIR_SPEED, AIR_ACCELERATION)
	else:
		velocity.x = lerp(velocity.x, 0.0, AIR_ACCELERATION * 0.5)


func handleJump() -> void:
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_STRENGTH

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
