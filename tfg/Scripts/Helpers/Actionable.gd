class_name Actionable extends Area2D


@export var dialogueResource: DialogueResource
@export var dialogueStart: String = "start"


func action() -> void:
	
	DialogueManager.show_dialogue_balloon(dialogueResource, dialogueStart)
