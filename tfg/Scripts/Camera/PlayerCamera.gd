class_name PlayerCamera extends Camera2D

@export var TILEMAP: TileMapLayer


func _ready() -> void:
	setCameraLimits(TILEMAP.get_used_rect())


func setCameraLimits(rect: Rect2i) -> void:
	limit_left = rect.position.x
	limit_right = (rect.position.x + rect.size.x) * 16
	limit_bottom = (rect.position.y + rect.size.y) * 16
	
