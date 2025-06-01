class_name TheSwordMasterTutorial
extends CharacterBody2D

@export var firstPathPoints: Array[Vector2] = [
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
@export var startMovingOnReady: bool = false

@onready var ItemDrop = preload("res://Scenes/Interactables/Item.tscn")

var currentTargetIndex: int = 0
var isActive: bool = false
var isMoving: bool = false
var hasCompletedPath: bool = false
var isJumping: bool = false
var horizontalDirection: float = 0
var currentPathPoints = null
var playerReference: Player
var justPlayedDialog = 0
var amountSpawned = 0
var needsToSpawnItem: bool
var enemiesDead: bool = false


func _ready() -> void:
	currentPathPoints = firstPathPoints
	if startMovingOnReady:
		startMoving()

func startMoving() -> void:
	if currentPathPoints.size() == 0:
		push_warning("Path is empty - NPC won't move")
		return
	isActive = true
	hasCompletedPath = false
	isMoving = true

func _process(delta: float) -> void:
	$Indicator.visible = playerReference and justPlayedDialog != 4 and !isMoving
	
	needsToSpawnItem = Dialogic.VAR.get_variable("SwordMasterTutorial.NeedsToSpawnItem")
	
	if playerReference and Input.is_action_just_pressed("Interact") and !isMoving:
		$Indicator.visible = false
		onPlayerInteract()
		
	if needsToSpawnItem and amountSpawned == 0:
		amountSpawned += 1
		await Dialogic.timeline_ended
		spawnItem()
		Dialogic.VAR.set_variable("SwordMasterTutorial.NeedsToSpawnItem", false)

func _physics_process(delta: float) -> void:
	if not isActive or hasCompletedPath or not isMoving:
		return
	
	if !Dialogic.VAR.get_variable("SwordMasterTutorial.FirstDialog"):
		return
	
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var targetPosition = currentPathPoints[currentTargetIndex]
	var direction = (targetPosition - global_position).normalized()
	var distance = global_position.distance_to(targetPosition)
	
	var needsToJump = targetPosition.y < global_position.y - 20
	
	if abs(direction.x) > 0.1: 
		horizontalDirection = sign(direction.x)
		velocity.x = horizontalDirection * walkSpeed
		
		if horizontalDirection > 0:
			$AnimationPlayer.play("Run_Right")
		else:
			$AnimationPlayer.play("Run_LEFT")
	else:
		velocity.x = 0
	
	if needsToJump and is_on_floor():
		if horizontalDirection > 0:
			$AnimationPlayer.play("Jump_Right")
		else:
			$AnimationPlayer.play("Jump_Left")
		velocity.y = jumpVelocity
		isJumping = true
	
	if distance < 5.0:
		currentTargetIndex += 1
		if currentTargetIndex >= currentPathPoints.size():
			hasCompletedPath = true
			isActive = false
			isMoving = false  # Aquí lo ponemos a false al acabar
			onPathCompleted()
	
	move_and_slide()

func onPathCompleted() -> void:
	print("NPC has completed its path")
	if currentPathPoints == firstPathPoints:
		global_position = Vector2(1120,246)
		$AnimationPlayer.play("Idle_Left")
	elif currentPathPoints == secondPathPoints:
		global_position = Vector2(1741,247)
		$AnimationPlayer.play("Idle_Left")
	elif currentPathPoints == thirdPathPoints:
		$AnimationPlayer.play("Idle")


func onPlayerInteract():
	var FistDialog = Dialogic.VAR.get_variable("SwordMasterTutorial.FirstDialog")
	var SecondDialog = Dialogic.VAR.get_variable("SwordMasterTutorial.SecondDialog")
	var ThirdDialog = Dialogic.VAR.get_variable("SwordMasterTutorial.ThirdDialog")
	var FourthDialog = Dialogic.VAR.get_variable("SwordMasterTutorial.FourthDialog")
	var FinalDialog = Dialogic.VAR.get_variable("SwordMasterTutorial.FinalTutorialDialog")

	if GameManager.hasLoadedGame and !FistDialog and !SecondDialog:
		global_position = Vector2(1741,247)
		Dialogic.VAR.set_variable("SwordMasterTutorial.FirstDialog", true)
		Dialogic.VAR.set_variable("SwordMasterTutorial.SecondDialog", true)
		FistDialog = true
		SecondDialog = true
		$AnimationPlayer.play("Idle_Left")
		currentPathPoints = thirdPathPoints
		GameManager.hasLoadedGame = false
		

	if !FistDialog and !SecondDialog and !ThirdDialog and !FourthDialog:
		GameManager.setDialogState(true) 
		Dialogic.start("res://Dialogues/Timelines/TheSwordMasterTutorialTimeline.dtl")
		justPlayedDialog = 1
	elif FistDialog and !SecondDialog and !ThirdDialog and !FourthDialog:
		GameManager.setDialogState(true) 
		Dialogic.start("res://Dialogues/Timelines/TheSwordMasterCheckpointExplanation.dtl")
		justPlayedDialog = 2
	elif FistDialog and SecondDialog and !ThirdDialog and !FourthDialog:
		GameManager.setDialogState(true) 
		Dialogic.start("res://Dialogues/Timelines/TheSwordmasterAMDialogue.dtl")
		justPlayedDialog = 3
	elif FistDialog and SecondDialog and ThirdDialog and !FourthDialog and enemiesDead:
		GameManager.setDialogState(true) 
		Dialogic.start("res://Dialogues/Timelines/TheSwordMasterTutorialFinalDialog.dtl")
		justPlayedDialog = 4
	elif FistDialog and SecondDialog and ThirdDialog and FourthDialog and enemiesDead:
		GameManager.setDialogState(true) 
		Dialogic.start("res://Dialogues/Timelines/TheSwordMasterTutorialFinale.dtl")
		justPlayedDialog = 5
	else:
		print("Failure")
	
	await Dialogic.timeline_ended
	
	if justPlayedDialog == 1:
		startMovingOnReady = true
		startMoving()
	elif justPlayedDialog == 2:
		hasCompletedPath = false
		isActive = true
		isMoving = true
		currentPathPoints = secondPathPoints
		currentTargetIndex = 0
	elif justPlayedDialog == 3:
		hasCompletedPath = false
		isActive = true
		isMoving = true
		currentPathPoints = thirdPathPoints
		currentTargetIndex = 0
	
	GameManager.setDialogState(false) 


func _on_actionable_player_in_range(body: Node2D) -> void:
	playerReference = body

func spawnItem():
	var dropForce: float = 150.0
	
	var spawnedItem = ItemDrop.instantiate()
	var parent = get_parent()
	if not parent:
		return
	parent.add_child(spawnedItem)
	spawnedItem.global_position = global_position + Vector2(0, -16)
	spawnedItem.itemName = "AttackModule"
	spawnedItem.itemTexture = load("res://Assets/Tilesets/Simple Items/SwordSprite.png")
	if spawnedItem is RigidBody2D:
		var direction = Vector2(-1, randf_range(-1.5, -0.5)).normalized()
		spawnedItem.apply_central_impulse(direction * dropForce)

func _on_actionable_player_out_of_range() -> void:
	playerReference = null

func _on_tutorial_scene_tutorial_done() -> void:
	enemiesDead = true 
	onPlayerInteract()

func _on_portal_teleport() -> void:
	onPlayerInteract()


func _on_player_awake() -> void:
	onPlayerInteract()
