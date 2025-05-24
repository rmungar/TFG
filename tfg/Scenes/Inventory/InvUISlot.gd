class_name InventoryUISlot extends Panel


@onready var ItemVisuals: Sprite2D = $CenterContainer/Panel/itemDisplay
@onready var label: Label = $CenterContainer/Panel/Label


func update(slot: InventorySlot) -> void:
	var reservedSlots := [
		"HealthModule",
		"AttackModule",
		"SkillModule"
	]
	
	if !slot.item:
		ItemVisuals.visible = false
		label.visible = false
	else:
		ItemVisuals.visible = true
		ItemVisuals.texture = slot.item.texture
		
		# Si el nombre del objeto NO está en la lista reservada, mostramos cantidad
		if slot.item.name in reservedSlots:
			label.visible = false
		else:
			label.visible = true
			label.text = str(slot.amount)
