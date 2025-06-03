extends AnimatedSprite2D

@export var target_position: Vector2 = Vector2(500, 200) # Cambia por las coordenadas deseadas

var spoken = false

func _ready():
	play("default")
	spoken = GameManager.talkedToIsilian


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and !spoken:
		flip_h = true
		GameManager.setDialogState(true) 
		Dialogic.start("res://Dialogues/Timelines/IsilianTimeline.dtl")
		await Dialogic.timeline_ended
		GameManager.setDialogState(false) 
		spoken = true
		GameManager.talkedToIsilian = true
