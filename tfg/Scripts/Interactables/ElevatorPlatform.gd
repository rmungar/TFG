class_name ElevatorPlatform extends RigidBody2D


@export var topPosition: Vector2
@export var bottomPosition: Vector2


var playerReference: Player = null
var currentPosition: Vector2

func _ready() -> void:
	global_position = topPosition
	$CollisionShape2D2.disabled = true
	$CollisionShape2D3.disabled = true
	currentPosition = topPosition


func _process(delta: float) -> void:
	if playerReference and Input.is_action_just_pressed("Interact"):
		startMoving()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		playerReference = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	playerReference = null


func startMoving():
	pass
