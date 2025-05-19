class_name InventoryUI extends Control


@onready var inventory: Inventory = preload("res://Scenes/Inventory/PlayerInv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

signal InventoryOpen
signal InventoryClosed

var isOpen = false


func _ready() -> void:
	inventory.update.connect(updateSlots)
	center_on_screen()
	get_viewport().connect("size_changed", center_on_screen)
	close()


func center_on_screen():
	var viewport_size = get_viewport_rect().size
	position = (viewport_size - size) * 0.5


func updateSlots() -> void:
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Inventory"):
		if isOpen:
			close()
			GameManager.inventoryClosed()
		else:
			open()
			GameManager.inventoryOpen()


func open() -> void:
	visible = true
	isOpen = true

func close() -> void:
	visible = false
	isOpen = false
