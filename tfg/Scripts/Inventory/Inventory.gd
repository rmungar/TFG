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
	var itemSlots = slots.filter(func(slot): return slot.item and slot.item.name == itemName)
	if itemSlots.is_empty():
		return false
	else:
		return true


func serialize() -> Array:
	var serializedSlots = []
	for slot in slots:
		if slot.item != null:
			serializedSlots.append({
				"name": slot.item.name,
				"texture_path": slot.item.texture.resource_path,
				"amount": slot.amount
			})
		else:
			serializedSlots.append(null)  # Slot vacío
	return serializedSlots


func deserialize(data: Array) -> void:
	slots.clear()
	for entry in data:
		var slot = InventorySlot.new()
		if entry != null:
			var item = InventoryItem.new()
			item.name = entry.get("name", "")
			item.texture = load(entry.get("texture_path", ""))
			slot.item = item
			slot.amount = entry.get("amount", 1)
		slots.append(slot)
	update.emit()



func equip_gem_on_double_click(slotIndex: int) -> void:
	if slotIndex < 0 or slotIndex >= slots.size():
		push_warning("Índice de slot fuera de rango.")
		return

	var clickedSlot := slots[slotIndex]
	var item := clickedSlot.item

	var gemSlotIndex := 11

	# Desequipar si se hace doble clic sobre el slot de la gema
	if slotIndex == gemSlotIndex:
		if item != null and item.name.contains("Gem"):
			clickedSlot.item = null
			clickedSlot.amount = 0
			insert(item)  # Reinsertar en inventario general
			update.emit()
		return

	# No es una gema, no hacer nada
	if item == null or not item.name.contains("Gem"):
		return

	var gemSlot := slots[gemSlotIndex]

	# Intercambiar si ya hay una gema en el slot de habilidad
	if gemSlot.item != null:
		# Swap de ítems y cantidades
		var tempItem = gemSlot.item
		var tempAmount = gemSlot.amount

		gemSlot.item = item
		gemSlot.amount = clickedSlot.amount

		clickedSlot.item = tempItem
		clickedSlot.amount = tempAmount
	else:
		# Mover directamente la gema
		gemSlot.item = item
		gemSlot.amount = clickedSlot.amount

		clickedSlot.item = null
		clickedSlot.amount = 0
	update.emit()

func getItemName(index: int):
	return slots[index].item

func isGemEquipped(name: String) -> bool:
	var skillSlot := slots[11]  
	if skillSlot.item and skillSlot.item.name.contains("Gem"):
		return skillSlot.item.name == name
	return false
