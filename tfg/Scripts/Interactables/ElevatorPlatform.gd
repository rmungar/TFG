class_name ElevatorPlatform
extends AnimatableBody2D

@export var topPosition: Vector2
@export var bottomPosition: Vector2
@export var elevatorSpeed: float = 200.0

var playerReference: Player = null
var moving := false
var goingDown := true
var hasBeenCalled := false

func _ready() -> void:
	global_position = topPosition
	# Asegúrate de que las colisiones estén habilitadas si es necesario
	$CollisionShape2D2.disabled = true
	$CollisionShape2D3.disabled = true
	$Indicator.visible = false

func _process(delta: float) -> void:
	#print("Elevator pos: ", global_position)
	pass	


func _physics_process(delta: float) -> void:
	if moving:
		var target = bottomPosition if goingDown else topPosition
		var direction = (target - global_position).normalized()
		var moveAmount = direction * elevatorSpeed * delta

		if global_position.distance_to(target) < moveAmount.length():
			global_position = target
			moving = false
			goingDown = !goingDown
			$CollisionShape2D2.disabled = true
			$CollisionShape2D3.disabled = true
			if !hasBeenCalled: 
				playerReference.canMove = true
			if hasBeenCalled: 
				hasBeenCalled = false
		else:
			global_position += moveAmount

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") and playerReference and not moving:
		startMoving()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if !moving: $Indicator.visible = true
		playerReference = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		$Indicator.visible = false
		playerReference = null

func startMoving():
	$CollisionShape2D2.disabled = false
	$CollisionShape2D3.disabled = false
	playerReference.canMove = false
	moving = true


func _on_call() -> void:
	hasBeenCalled = true
	if global_position == topPosition:
		$CollisionShape2D2.disabled = false
		$CollisionShape2D3.disabled = false
		moving = true
		goingDown = true
	else:
		$CollisionShape2D2.disabled = false
		$CollisionShape2D3.disabled = false
		moving = true
		goingDown = false
