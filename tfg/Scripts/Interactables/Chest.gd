class_name Chest extends StaticBody2D

@export var itemDropScene: PackedScene
@export var dropForce: float = 150.0
@export var canDropMultipleItems: bool = false
@export var dropTable: Array[Dictionary] = [
]

var isOpened: bool = false

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if not isOpened and body.is_in_group("player"):
		open_chest(body)

func open_chest(opener: Node2D):
	isOpened = true
	$AnimationPlayer.play("open")
	
	var itemsToDrop = get_items_from_drop_table()
	
	for itemScene in itemsToDrop:
		var item = itemScene.instantiate()
		get_parent().add_child(item)
		item.global_position = $ItemSpawnPoint.global_position
		
		var dropDirection = Vector2(
			randf_range(-1, 1),
			randf_range(-0.5, -1.5)
		).normalized()
		item.apply_impulse(dropDirection * dropForce)

func get_items_from_drop_table() -> Array:
	var drops: Array = []
	
	if canDropMultipleItems:

		var totalWeight = dropTable.reduce(func(sum, entry): return sum + entry["weight"], 0)
		var dropsCount = randi_range(1, 3) 
		
		for i in dropsCount:
			var randomWeight = randf() * totalWeight
			var cumulativeWeight = 0.0
			
			for entry in dropTable:
				cumulativeWeight += entry["weight"]
				if randomWeight <= cumulativeWeight:
					drops.append(entry["item"])
					break
	else:
		
		var totalWeight = dropTable.reduce(func(sum, entry): return sum + entry["weight"], 0)
		var randomWeight = randf() * totalWeight
		var cumulativeWeight = 0.0
		
		for entry in dropTable:
			cumulativeWeight += entry["weight"]
			if randomWeight <= cumulativeWeight:
				drops.append(entry["item"])
				break
	
	return drops
