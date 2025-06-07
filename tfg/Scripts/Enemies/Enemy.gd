class_name Enemy extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var collisionShape: CollisionShape2D = $CollisionShape2D

@export_category("Physics")
@export var speed: float = 50
@export var gravity: float = 980.0

@export_category("Health")
@export var maxHP = 3
@export var currentHP = 3

@export var spawnPosition: Vector2

var lastSafePosition: Vector2

@export var reward: int

func _physics_process(delta: float) -> void:
	if is_on_floor(): 
		lastSafePosition = global_position
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()


func _on_take_damage(amount: int) -> void:
	currentHP -= amount
	if currentHP <= 0:
		queue_free()


func teleport(newPosition: Vector2):
	global_position = newPosition
