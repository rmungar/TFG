class_name InventorySlot extends Panel


@onready var ItemVisuals: Sprite2D = $CenterContainer/Panel/itemDisplay


func update(item: InventoryItem)-> void:
	if !item:
		ItemVisuals.visible = false
	else:
		ItemVisuals.visible = true
		ItemVisuals.texture = item.texture
