class_name Enemy extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var collisionShape: CollisionShape2D = $CollisionShape2D

@export_category("Physics")
@export var speed: float
@export var gravity: float = 980.0

@export_category("Health")
@export var maxHP = 3
@export var currentHP = 3


func _on_take_damage(amount: int) -> void:
	currentHP -= amount
	if currentHP <= 0:
		queue_free()
