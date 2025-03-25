class_name Player extends CharacterBody2D


@export var SPEED: float = 200.0
@export var JUMP_VELOCITY: float = -350.0
@export var GRAVITY: float = 980.0
@export var DELECERATION: float = 0.2


func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Handle jump
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle directions
	var facingDirection: float = 0.0
	if Input.is_action_pressed("MoveLeft"):
		facingDirection = -1.0
	elif Input.is_action_pressed("MoveRight"):
		facingDirection = 1.0
	
	if facingDirection != 0:
		velocity.x = facingDirection * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * DELECERATION)

	move_and_slide()
