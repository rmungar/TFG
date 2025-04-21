class_name Player extends CharacterBody2D

@onready var SPRITE: Sprite2D = $Sprite2D
@onready var ANIMATION_PLAYER: AnimationPlayer = $AnimationPlayer
@onready var STATE_MACHINE: StateMachine = $StateMachine
@export var SPEED: float = 200.0
@export var AIR_SPEED: float = -150.0
@export var AIR_ACCELERATION: float = 0.1
@export var JUMP_STRENGTH: float = -350.0
@export var GRAVITY: float = 980.0
@export var DELECERATION: float = 0.2
var FACINGDIRECTION: float 
@export var HP: int = 100

func _ready() -> void:
	STATE_MACHINE.configure(self)

func _process(delta: float) -> void:
	# Handle directions
	if Input.is_action_pressed("MoveLeft"):
		FACINGDIRECTION = -1.0
		SPRITE.flip_h = true
	elif Input.is_action_pressed("MoveRight"):
		FACINGDIRECTION = 1.0
		SPRITE.flip_h = false
	
	

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	if not Input.is_action_pressed("MoveLeft") and not Input.is_action_pressed("MoveRight"):
		FACINGDIRECTION = 0
	move_and_slide()
