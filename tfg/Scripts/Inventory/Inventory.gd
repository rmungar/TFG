class_name Inventory extends Resource

signal update

@export var slots: Array[InventorySlot]


func insert(newInvItem: InventoryItem):
	var itemSlots = slots.filter(func(slot): return slot.item == newInvItem)
	if !itemSlots.is_empty():
		itemSlots[0].amount += 1
	else:
		var emptySlots = slots.filter(func(slot): return slot.item == null)
		if !emptySlots.is_empty():
			emptySlots[0].item = newInvItem
			emptySlots[0].amount = 1
			
	update.emit()


func search(itemName: String) -> bool:
	var itemSlots = slots.filter(func(slot): return slot.item.name == itemName)
	if itemSlots.is_empty():
		return false
	else:
		return true
