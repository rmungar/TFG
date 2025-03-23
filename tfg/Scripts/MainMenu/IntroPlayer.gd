extends CharacterBody2D

@export var speed: float = 50.0

func _physics_process(delta: float) -> void:
	velocity.x = speed
	move_and_slide()
