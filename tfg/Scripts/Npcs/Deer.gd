extends CharacterBody2D

var scared: bool = false
var hasReachedTarget: bool = false
var isMoving: bool = false

@export var speed: float = 75.0
@export var targetPosition: Vector2 = Vector2(1114.0, 240.0)

func _physics_process(delta: float) -> void:
	if scared:
		handle_scared_behavior()
	elif not hasReachedTarget:
		move_to_target(delta)
	else:
		$AnimatedSprite2D.play("Eat")

func move_to_target(delta: float):
	if not isMoving:
		$AnimatedSprite2D.play("Walk")
		isMoving = true
	
	var direction = (targetPosition - global_position).normalized()
	if direction.x != 0:
		$AnimatedSprite2D.flip_h = direction.x < 0
	
	velocity = direction * speed
	move_and_slide()
	if global_position.distance_to(targetPosition) < 5.0:
		hasReachedTarget = true
		isMoving = false
		$AnimatedSprite2D.play("Eat")

func handle_scared_behavior():
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("Disappear")
	await $AnimatedSprite2D.animation_finished
	queue_free()

func _on_door_opened():
	scared = true
	$AnimatedSprite2D.play("Look Up")
