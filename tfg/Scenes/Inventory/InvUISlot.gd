class_name InventoryUISlot extends Panel


@onready var ItemVisuals: Sprite2D = $CenterContainer/Panel/itemDisplay
@onready var label: Label = $CenterContainer/Panel/Label


func update(slot: InventorySlot)-> void:
	if !slot.item:
		ItemVisuals.visible = false
		label.visible = false
	else:
		ItemVisuals.visible = true
		ItemVisuals.texture = slot.item.texture
		label.visible = true
		label.text = str(slot.amount)
