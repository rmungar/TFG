class_name Enemy extends CharacterBody2D

@onready var SPRITE: Sprite2D = $Sprite2D
@onready var ANIMATION_PLAYER: AnimationPlayer = $AnimationPlayer
@onready var COLLISION_SHAPE: CollisionShape2D = $CollisionShape2D

@export_category("Physics")
@export var SPEED: float
@export var GRAVITY: float = 980.0

@export_category("Health")
@export var MAX_HP = 3
@export var CURRENT_HP = 3

var FACING_DIRECTION: float = -1.0


func _ready() -> void:
	print("Enemy current health: ", CURRENT_HP)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	move_and_slide()


func _on_take_damage(amount: int) -> void:
	CURRENT_HP -= amount
	if CURRENT_HP <= 0:
		queue_free()
