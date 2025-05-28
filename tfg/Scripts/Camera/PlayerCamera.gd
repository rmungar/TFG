class_name PlayerCamera extends Camera2D

@export var tileMap: TileMapLayer


func _ready() -> void:
	setCameraLimits(tileMap.get_used_rect())


func setCameraLimits(rect: Rect2i) -> void:
	var cell_size = tileMap.tile_set.tile_size
	limit_left = rect.position.x * cell_size.x
	limit_right = (rect.position.x + rect.size.x) * cell_size.x
	limit_top = rect.position.y * cell_size.y
	limit_bottom = (rect.position.y + rect.size.y) * cell_size.y



func changeRect(newTileMap: TileMapLayer):
	setCameraLimits(newTileMap.get_used_rect())
	tileMap = newTileMap
