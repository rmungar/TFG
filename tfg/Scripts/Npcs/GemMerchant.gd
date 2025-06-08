class_name GemMerchant extends Merchant

var hasTalkedBefore := false

func _ready():
	hasTalkedBefore = GameManager.talkedToMerchant


func _process(delta: float) -> void:
	if playerReference and Input.is_action_just_pressed("Interact") and !shopUI.visible and !GameManager.pauseMenuOpen and !GameManager.isInventoryOpen:
		print(hasTalkedBefore)
		start_interaction()
		if hasTalkedBefore: 
			await Dialogic.timeline_ended
			openShop()
		else:
			hasTalkedBefore = true
			GameManager.talkedToMerchant = true
	elif playerReference and Input.is_action_just_pressed("Interact") and shopUI.visible:
		closeShop()
		if hasTalkedBefore: endInteraction()



func start_interaction():
	if not hasTalkedBefore:
		GameManager.setDialogState(true)
		Dialogic.start("res://Dialogues/Timelines/GemMerchantFirstInteractionTimeline.dtl")
		await Dialogic.timeline_ended
		GameManager.setDialogState(false)
		
	else:
		GameManager.setDialogState(true)
		Dialogic.start("res://Dialogues/Timelines/GemMerchantRegularTimeline.dtl")
		await Dialogic.timeline_ended
		GameManager.setDialogState(false)


func endInteraction():
	GameManager.setDialogState(true)
	Dialogic.start("res://Dialogues/Timelines/GemMerchantEndTimeline.dtl")
	await Dialogic.timeline_ended
	GameManager.setDialogState(false)
