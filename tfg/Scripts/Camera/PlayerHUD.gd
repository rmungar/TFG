class_name PlayerHUD extends Control

@onready var healthContainer: HBoxContainer = $CanvasLayer/HealthContainer
@onready var moneyLabel: Label = $CanvasLayer/MoneyLabel

@export var HPPerHeart: int = 20
@export var fullTexture: Texture2D
@export var halfTexture: Texture2D
@export var emptyTtexture: Texture2D


func _ready() -> void:
	$CanvasLayer/SaveIcon.visible = false


func updateHealth(current_hp: int, max_hp: int) -> void:
	print("UPDATE")
	var units = int(ceil(max_hp / HPPerHeart))
	
	# Limpiar los iconos existentes
	queueFreeChildren()

	for i in range(units):
		var icon = TextureRect.new()
		var unitValue = clamp(current_hp - (i * HPPerHeart), 0, HPPerHeart)

		if unitValue == HPPerHeart:
			icon.texture = fullTexture
			icon.modulate = Color.PALE_GREEN
		elif unitValue >= HPPerHeart / 2:
			icon.texture = halfTexture
			icon.modulate = Color.LIGHT_YELLOW
		else:
			icon.texture = emptyTtexture
		
		icon.custom_minimum_size = Vector2(16, 16)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		
		healthContainer.add_child(icon)

func queueFreeChildren():
	for child in healthContainer.get_children():
		child.queue_free()


func _on_save_point_save() -> void:
	$CanvasLayer/SaveIcon.visible = true
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.start(2)
	await timer.timeout
	$CanvasLayer/SaveIcon.visible = false
	remove_child(timer)


func updateMoney(money: int) -> void:
	moneyLabel.text = str(money)
