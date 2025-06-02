class_name SavePoint extends Node2D

signal unlock()
signal save()

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@export var requiredItem = ""
@export var alreadyInteracted: bool = false
@export var tilemap: TileMapLayer
@export var postTutorial: bool
var playerReference: Player = null
var interactable: bool = false
var times = 0
signal Interactable


func _ready() -> void:
	$Indicator.visible = false

func _process(delta: float) -> void:
	if alreadyInteracted == true:
		self.modulate = Color(0.0, 0.74, 1.0, 1.0)
	else:
		self.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if playerReference and Input.is_action_just_pressed("Interact"):
		playerReference.lastCheckPoint = global_position
		playerReference.lastTilemap = tilemap.name
		if requiredItem == "" or playerReference.has_item(requiredItem):
			if postTutorial:
				GameManager.tutorial_done = true
			alreadyInteracted = true
			$Indicator.visible = false
			save.emit()
			GameManager.onSave(playerReference, GameManager.tutorial_done)
			emit_signal("unlock")


func inInteractionRange(body: Node2D) -> void:
	interactable = true
	if times == 0 and !GameManager.hasLoadedGame:
		Interactable.emit()
		times += 1
	if !alreadyInteracted:
		$Indicator.visible = true

func inDetectionRange(body: Node2D) -> void:
	if body is Player:
		playerReference = body
		animatedSprite.play("StartUp")
		await animatedSprite.animation_finished
		animatedSprite.play("Idle")

func leftDetectionRange(body: Node2D) -> void:
	playerReference = null
	animatedSprite.play("Close")
	$Indicator.visible = false

func leftInteractionRange(body: Node2D) -> void:
	interactable = true
