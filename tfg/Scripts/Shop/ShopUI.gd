extends Control
class_name ShopUI

@export var shopInventory: Inventory
@onready var slots: Array = $GridContainer.get_children()
signal itemPurchased(item: InventoryItem)

var playerInventory: Inventory = preload("res://Scenes/Inventory/PlayerInv.tres")  

func _ready():
	visible = false
	shopInventory.update.connect(update_slots)
	update_slots()
	connect_double_clicks()

func update_slots():
	for i in range(min(shopInventory.slots.size(), slots.size())):
		slots[i].update(shopInventory.slots[i])

func connect_double_clicks():
	for i in range(slots.size()):
		slots[i].connect("gui_input", Callable(self, "_on_slot_input").bind(i))

func _on_slot_input(event: InputEvent, index: int):
	print("Click")
	if event is InputEventMouseButton and event.double_click and event.button_index == MOUSE_BUTTON_LEFT:
		var item_slot = shopInventory.slots[index]
		if item_slot and item_slot.item:
			print("Comprando:", item_slot.item.name)
			playerInventory.insert(item_slot.item)  
			itemPurchased.emit(item_slot.item)
			item_slot.amount -= 1
			if item_slot.amount <= 0:
				item_slot.item = null
			shopInventory.update.emit()

func open():
	visible = true
	GameManager.setShopInScreenState(true)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func close():
	visible = false
	GameManager.setShopInScreenState(false)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
