class_name TutorialDoorsManager extends Node2D

var playerReference: Player = null
var currentDoorReference = 0
@onready var doors: TutorialDoorsManager = $"."

var door1Coordinates: Vector2
var door2Coordinates: Vector2
var door3Coordinates: Vector2
var door4Coordinates: Vector2

func _ready() -> void:
	door1Coordinates = doors.get_node("Door1").global_position
	door2Coordinates = doors.get_node("Door2").global_position
	door3Coordinates = doors.get_node("Door3").global_position
	door4Coordinates = doors.get_node("Door4").global_position


func _process(delta: float) -> void:
	if playerReference and currentDoorReference != 0 and Input.is_action_just_pressed("Interact"):
		var originalCollision = playerReference.collision_mask
		
		playerReference.collision_mask = 0
		
		var targetPosition: Vector2
		match currentDoorReference:
			1: 
				targetPosition = door2Coordinates
				print("Teleporting to Door2 pos: ", targetPosition)
			2: 
				targetPosition = door3Coordinates
				print("Teleporting to Door3 pos: ", targetPosition)
			3: 
				targetPosition = door4Coordinates
				print("Teleporting to Door4 pos: ", targetPosition)
			4: 
				targetPosition = playerReference.global_position
		
		playerReference.global_position = targetPosition
		playerReference.force_update_transform()
		
		await get_tree().physics_frame
		
		playerReference.collision_mask = originalCollision


func onTutorialDoor1Entered(body: Node2D) -> void:
	if body is Player:
		playerReference = body
		currentDoorReference = 1


func onTutorialDoor1Exited(body: Node2D) -> void:
	playerReference = null
	currentDoorReference = 0


func onTutorialDoor2Entered(body: Node2D) -> void:
	if body is Player:
		playerReference = body
		currentDoorReference = 2


func onTutorialDoor2Exited(body: Node2D) -> void:
	playerReference = null
	currentDoorReference = 0


func onTutorialDoor3Entered(body: Node2D) -> void:
	if body is Player:
		playerReference = body
		currentDoorReference = 3


func onTutorialDoor3Exited(body: Node2D) -> void:
	playerReference = null
	currentDoorReference = 0


func onTutorialDoor4Entered(body: Node2D) -> void:
	if body is Player:
		playerReference = body
		currentDoorReference = 4


func onTutorialDoor4Exited(body: Node2D) -> void:
	playerReference = null
	currentDoorReference = 0
