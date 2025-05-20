class_name TheSwordMasterTutorial extends CharacterBody2D

@export var fisrtPathPoints: Array[Vector2] = [
	Vector2(278,244), 
	Vector2(328,195),
	Vector2(392,166),
	Vector2(372,166),
	Vector2(298,114),
	Vector2(245,69),
	Vector2(95,69)
]

@export var secondPathPoints: Array[Vector2] = [
	Vector2(1376,245), 
]

@export var thirdPathPoints: Array[Vector2] = [
	Vector2(1812,247),
	Vector2(1865,196),
	Vector2(1934,196),
	Vector2(1994,168),
	Vector2(2057,168),
	Vector2(2140,247),
	Vector2(2220,247),
	Vector2(2241,212),
	Vector2(2677,247)
]

@export var walkSpeed: float = 100.0
@export var jumpVelocity: float = -350.0
@export var gravity: float = 1000.0
@export var startMovingOnReady: bool = true


@onready var ItemDrop = preload("res://Scenes/Interactables/Item.tscn")


var currentTargetIndex: int = 0
var isActive: bool = false
var hasCompletedPath: bool = false
var isJumping: bool = false
var horizontalDirection: float = 0
var currentPathPoints = null
var playerReference: Player
var justPlayedDialog = 0
var amountSpawned = 0
var needsToSpawnItem: bool



func _ready() -> void:
	currentPathPoints = fisrtPathPoints
	if startMovingOnReady:
		startMoving()
		
	needsToSpawnItem = Dialogic.VAR.get_variable("NeedsToSpawnItem")

func _process(delta: float) -> void:
	if playerReference and Input.is_action_just_pressed("Interact"):
		onPlayerInteract()
		
	if needsToSpawnItem and amountSpawned == 0:
		await Dialogic.timeline_ended
		amountSpawned += 1
		spawnItem()
		Dialogic.VAR.set_variable("SwordMasterTutorial.NeedsToSpawnItem", false)

func startMoving() -> void:
	if currentPathPoints.size() == 0:
		push_warning("Path is empty - NPC won't move")
		return
	isActive = true
	hasCompletedPath = false

func _physics_process(delta: float) -> void:
	if not isActive or hasCompletedPath:
		return
	
	if !Dialogic.VAR.get_variable("SwordMasterTutorial.FirstDialog"):
		return
	
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var targetPosition = currentPathPoints[currentTargetIndex]
	var direction = (targetPosition - global_position).normalized()
	var distance = global_position.distance_to(targetPosition)
	
	# Determine if we need to jump (target is significantly higher)
	var needsToJump = targetPosition.y < global_position.y - 20
	
	# Horizontal movement
	if abs(direction.x) > 0.1: 
		horizontalDirection = sign(direction.x)
		velocity.x = horizontalDirection * walkSpeed
		
		# Face the correct direction
		if horizontalDirection > 0:
			$AnimationPlayer.play("Run_Right")
		else:
			$AnimationPlayer.play("Run_LEFT")
	else:
		velocity.x = 0
	
	# Jump logic
	if needsToJump and is_on_floor():
		if horizontalDirection > 0:
			$AnimationPlayer.play("Jump_Right")
		else:
			$AnimationPlayer.play("Jump_Left")
		velocity.y = jumpVelocity
		isJumping = true
	
	# Check if reached target
	if distance < 5.0:
		currentTargetIndex += 1
		if currentTargetIndex >= currentPathPoints.size():
			hasCompletedPath = true
			isActive = false
			onPathCompleted()
	
	move_and_slide()

func onPathCompleted() -> void:
	print("NPC has completed its path")
	if currentPathPoints == fisrtPathPoints:
		self.global_position = Vector2(1120,246)
		$AnimationPlayer.play("Idle_Left")
	elif currentPathPoints == secondPathPoints:
		self.global_position = Vector2(1741,247)
		$AnimationPlayer.play("Idle_Left")
	elif currentPathPoints == thirdPathPoints:
		$AnimationPlayer.play("Idle")


func onPlayerInteract():
	var FistDialog = Dialogic.VAR.get_variable("SwordMasterTutorial.FirstDialog")
	var SecondDialog = Dialogic.VAR.get_variable("SwordMasterTutorial.SecondDialog")
	var ThirdDialog = Dialogic.VAR.get_variable("SwordMasterTutorial.ThirdDialog")
	var FourthDialog = Dialogic.VAR.get_variable("SwordMasterTutorial.FourthDialog")
	
	
	if !FistDialog and !SecondDialog and !ThirdDialog and !FourthDialog:
		GameManager.isDialogInScreen = true
		Dialogic.start("res://Dialogues/Timelines/TheSwordMasterTutorialTimeline.dtl")
		justPlayedDialog = 1
	elif FistDialog and !SecondDialog and !ThirdDialog and !FourthDialog:
		GameManager.isDialogInScreen = true
		Dialogic.start("res://Dialogues/Timelines/TheSwordMasterCheckpointExplanation.dtl")
		justPlayedDialog = 2
	elif FistDialog and SecondDialog and !ThirdDialog and !FourthDialog:
		GameManager.isDialogInScreen = true
		Dialogic.start("res://Dialogues/Timelines/TheSwordmasterAMDialogue.dtl")
		justPlayedDialog = 3
	elif FistDialog and SecondDialog and ThirdDialog and !FourthDialog:
		GameManager.isDialogInScreen = true
		Dialogic.start("")
		justPlayedDialog = 4
	else:
		print("Failure")
	
	await Dialogic.timeline_ended
	
	if justPlayedDialog == 2:
		hasCompletedPath = false
		isActive = true
		currentPathPoints = secondPathPoints
		currentTargetIndex = 0
		
	elif justPlayedDialog == 3:
		hasCompletedPath = false
		isActive = true
		currentPathPoints = thirdPathPoints
		currentTargetIndex = 0
	
	GameManager.isDialogInScreen = false


func _on_actionable_player_in_range(body: Node2D) -> void:
	playerReference = body


func spawnItem():
	var dropForce: float = 150.0
	
	var spawnedItem = ItemDrop.instantiate()
	var parent = get_parent()
	if not parent:
		push_error("Can't spawn the item!")
		return
	parent.add_child(spawnedItem)
	spawnedItem.global_position = global_position + Vector2(0, -16)
	print("Item position set to: ", spawnedItem.global_position)
	spawnedItem.itemName = "Attack module"
	if spawnedItem is RigidBody2D:
		var direction = Vector2(
			randf_range(-1, 1),
			randf_range(-1.5, -0.5)
		).normalized()
		spawnedItem.apply_central_impulse(direction * dropForce)
		print("Impulse applied: ", direction * dropForce)
	else:
		push_warning("Item is not a RigidBody2D - can't apply impulse")
	


func _on_actionable_player_out_of_range() -> void:
	playerReference = null
