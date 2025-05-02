class_name TutorialDoorsManager extends Node2D

var playerReference: Player = null
var currentDoorReference = 0
@onready var door1: Area2D = get_node("/root/TutorialScene/Doors/Door1")
@onready var door2: Area2D = get_node("/root/TutorialScene/Doors/Door2")
@onready var door3: Area2D = get_node("/root/TutorialScene/Doors/Door3")
@onready var doors: TutorialDoorsManager = $"."


func _process(delta: float) -> void:
	if playerReference and currentDoorReference != 0 and Input.is_action_just_pressed("Interact"):
		var originalCollision = playerReference.collision_mask
		
		playerReference.collision_mask = 0
		
		var targetPosition: Vector2
		match currentDoorReference:
			1: 
				targetPosition = door2.global_position
				print("Teleporting to Door2 pos: ", targetPosition)
			2: 
				targetPosition = door3.global_position
				print("Teleporting to Door3 pos: ", targetPosition)
			3: 
				targetPosition = door3.global_position
				print("Teleporting to Door3 pos: ", targetPosition)
		
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
