class_name PlayerHUD extends Control

@onready var healthContainer: HBoxContainer = $CanvasLayer/HealthContainer
@export var HPPerHeart: int = 20
@export var fullTexture: Texture2D
@export var halfTexture: Texture2D
@export var emptyTtexture: Texture2D

func updateHealth(current_hp: int, max_hp: int) -> void:
	var units = int(ceil(max_hp / HPPerHeart))
	
	# Limpiar los iconos existentes
	queueFreeChildren()

	for i in range(units):
		var icon = TextureRect.new()
		var unitValue = clamp(current_hp - (i * HPPerHeart), 0, HPPerHeart)

		if unitValue == HPPerHeart:
			icon.texture = fullTexture
		elif unitValue >= HPPerHeart / 2:
			icon.texture = halfTexture
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
