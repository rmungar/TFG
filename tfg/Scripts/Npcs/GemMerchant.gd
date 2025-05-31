class_name GemMerchant extends Merchant

var hasTalkedBefore := false

func _ready():
	pass

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		start_interaction()

func start_interaction():
	if not hasTalkedBefore:
		hasTalkedBefore = true
		pass
