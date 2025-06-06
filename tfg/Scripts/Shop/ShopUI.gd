extends Control
class_name ShopUI

@export var shopInventory: Inventory
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
signal itemPurchased(item: InventoryItem)
var playerReference: Player
var playerInventory: Inventory = preload("res://Scenes/Inventory/PlayerInv.tres")  
var prices = [200, 200, 200, 400, 400, 400]

signal ReturnItem(item: InventoryItem)

func _ready():
	playerReference = get_tree().get_first_node_in_group("Player")
	center_on_screen()
	visible = false
	shopInventory.update.connect(update_slots)
	$NinePatchRect2.visible = false
	$Label.text = str(prices[0])
	$Label2.text = str(prices[1])
	$Label3.text = str(prices[2])
	$Label4.text = str(prices[3])
	$Label5.text = str(prices[4])
	$Label6.text = str(prices[5])
	
	update_slots()

func update_slots():
	for i in range(min(shopInventory.slots.size(), slots.size())):
		slots[i].update(shopInventory.slots[i])


func open():
	visible = true
	GameManager.setShopInScreenState(true)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func close():
	visible = false
	GameManager.setShopInScreenState(false)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	$NinePatchRect2.visible = false


func center_on_screen():
	var viewport_size = get_viewport_rect().size
	position = (viewport_size - size) * 0.5

func _on_buy(index: int) -> void:
	
	var item_slot = shopInventory.slots[index]
	if item_slot and item_slot.item:
		var item = item_slot.item
		var price = prices[index]
		if playerReference.money >= price:
			playerReference.money -= price
			playerInventory.insert(item)
			itemPurchased.emit(item)

			item_slot.amount -= 1
			if item_slot.amount <= 0:
				item_slot.item = null
			AudioManager.play_sound("res://Assets/Sounds/buy.mp3", -30.0)
			shopInventory.update.emit()
			playerReference.updateMoney.emit(playerReference.money)
		else:
			AudioManager.play_sound("res://Assets/Sounds/buyDenied.mp3", -30.0)


func getItem(index: int):
	$NinePatchRect2.visible = true
	var item = shopInventory.getItemName(index)
	ReturnItem.emit(item)
