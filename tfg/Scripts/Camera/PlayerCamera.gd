class_name PlayerCamera extends Camera2D

@export var tileMap: TileMapLayer
@export var look_offset: Vector2 = Vector2(0, 100)  # Desplazamiento al mirar hacia abajo
@export var look_speed: float = 5.0  # Velocidad de interpolación

var target_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	setCameraLimits(tileMap.get_used_rect())

func _process(delta: float) -> void:
	# Detectar entrada hacia abajo
	if Input.is_action_pressed("ui_down"):
		target_offset = look_offset
	elif Input.is_action_pressed("ui_up"):
		target_offset = -look_offset
	else:
		target_offset = Vector2.ZERO
	# Interpolación suave hacia el objetivo
	offset = offset.lerp(target_offset, delta * look_speed)



func setCameraLimits(rect: Rect2i) -> void:
	var cell_size = tileMap.tile_set.tile_size
	limit_left = rect.position.x * cell_size.x
	limit_right = (rect.position.x + rect.size.x) * cell_size.x
	limit_top = rect.position.y * cell_size.y
	limit_bottom = (rect.position.y + rect.size.y) * cell_size.y



func changeRect(newTileMap: TileMapLayer):
	setCameraLimits(newTileMap.get_used_rect())
	tileMap = newTileMap
