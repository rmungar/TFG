class_name ShopUISlot extends Control

signal double_clicked(index: int)

@onready var ItemVisuals: Sprite2D = $CenterContainer/Panel/itemDisplay
@onready var label: Label = $CenterContainer/Panel/Label

var click_timer := 0.0
var click_threshold := 0.3
var last_click_time := 0.0
@export var index: int

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.double_click:
		emit_signal("double_clicked", index)


func update(slot: InventorySlot) -> void:
	if !slot.item:
		ItemVisuals.visible = false
		label.visible = false
	else:
		ItemVisuals.visible = true
		ItemVisuals.texture = slot.item.texture
		label.visible = true
		label.text = str(slot.amount)
