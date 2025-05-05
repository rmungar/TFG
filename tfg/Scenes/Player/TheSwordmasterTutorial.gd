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
	Vector2(1838,245),
	Vector2(1933,203),
	Vector2(2036,169),
	Vector2(2178,245),
	Vector2(2439,139),
	Vector2(2454,145),
	Vector2(2515,118),
	Vector2(2599,119),
	Vector2(2676,245)
]

@export var walkSpeed: float = 100.0
@export var jumpVelocity: float = -350.0
@export var gravity: float = 1000.0
@export var startMovingOnReady: bool = true
@export var debugDrawPath: bool = true

var currentTargetIndex: int = 0
var isActive: bool = false
var hasCompletedPath: bool = false
var isJumping: bool = false
var horizontalDirection: float = 0
var currentPathPoints = null

func _ready() -> void:
	currentPathPoints = fisrtPathPoints
	if startMovingOnReady:
		startMoving()

func startMoving() -> void:
	if currentPathPoints.size() == 0:
		push_warning("Path is empty - NPC won't move")
		return
	isActive = true
	hasCompletedPath = false

func _physics_process(delta: float) -> void:
	if not isActive or hasCompletedPath:
		return
	
	if GameManager.isDialogInScreen:
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
	if abs(direction.x) > 0.1:  # Only move if significant horizontal distance
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
	elif currentPathPoints == secondPathPoints:
		self.global_position = Vector2(1741,247)
		$AnimationPlayer.play("Idle_Left")


func _on_mechanical_door_unlocked() -> void:
	hasCompletedPath = false
	isActive = true
	currentPathPoints = secondPathPoints
	currentTargetIndex = 0
