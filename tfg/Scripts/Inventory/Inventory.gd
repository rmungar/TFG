class_name Inventory extends Resource

signal update

@export var slots: Array[InventorySlot]


func insert(newInvItem: InventoryItem):
	var reservedSlots := {
		"HealthModule": 9,
		"AttackModule": 10,
		"SkillModule": 11
	}
	# Si el objeto es especial (Heal, Attack, Skill)
	if reservedSlots.has(newInvItem.name):
		var index = reservedSlots[newInvItem.name]
		var slot := slots[index]
		if slot.item == null or slot.item.name == newInvItem.name:
			slot.item = newInvItem
			slot.amount += 1
		else:
			push_error("El slot %d reservado para %s ya está ocupado por otro objeto." % [index, newInvItem.name])
		
		update.emit()
		
		return
		
	var generalSlots := slots.slice(0, 9)
	
	var matchingSlots := generalSlots.filter(func(slot): return slot.item == newInvItem)
	if !matchingSlots.is_empty():
		matchingSlots[0].amount += 1
	else:
		var emptySlots := generalSlots.filter(func(slot): return slot.item == null)
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
