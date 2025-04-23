class_name Player extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var stateMachine: StateMachine = $StateMachine
@export var speed: float = 200.0
@export var airSpeed: float = -150.0
@export var airAcceleration: float = 0.1
@export var jumpStrength: float = -350.0
@export var gravity: float = 980.0
@export var deceleration: float = 0.2
var facingDirection: float 
@export var HP: int = 100

func _ready() -> void:
	stateMachine.configure(self)

func _process(delta: float) -> void:
	# Handle directions
	if Input.is_action_pressed("MoveLeft"):
		facingDirection = -1.0
		sprite.flip_h = true
	elif Input.is_action_pressed("MoveRight"):
		facingDirection = 1.0
		sprite.flip_h = false
	
	

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if not Input.is_action_pressed("MoveLeft") and not Input.is_action_pressed("MoveRight"):
		facingDirection = 0
	move_and_slide()
