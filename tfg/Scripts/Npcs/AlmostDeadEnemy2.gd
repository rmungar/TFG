extends Sprite2D

var playerReference: Player = null


func _ready() -> void:
	$Indicator.visible = false


func _process(delta: float) -> void:
	if playerReference and Input.is_action_just_pressed("Interact"):
		GameManager.setDialogState(true)
		Dialogic.start("res://Dialogues/Timelines/AlmostDeadNPC2.dtl")
		await Dialogic.timeline_ended
		GameManager.setDialogState(false)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		playerReference = body
		$Indicator.visible = true



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		playerReference = null
		$Indicator.visible = false
