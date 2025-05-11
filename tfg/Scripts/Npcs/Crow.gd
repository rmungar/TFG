extends CharacterBody2D


var flyAway: bool = false
var flyDirection: Vector2 = Vector2.RIGHT
@export var flightSpeed: float = 200.0
func _on_door_opened():
	flyAway = true
	$AnimatedSprite2D.play("Fly")

func _physics_process(delta):
	if flyAway:
		velocity = flyDirection.normalized() * flightSpeed
		move_and_slide()
