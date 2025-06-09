class_name InventorySlot extends Resource

var lastClickTime := 0.0
const DOUBLE_CLICK_THRESHOLD := 0.3

signal item_purchased(item: InventoryItem)

@export var item: InventoryItem
@export var amount: int


func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var now = Time.get_ticks_msec() / 1000.0
		if now - lastClickTime <= DOUBLE_CLICK_THRESHOLD:
			item_purchased.emit(item)
		lastClickTime = now
