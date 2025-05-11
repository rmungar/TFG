class_name ArcherBandit extends Enemy

var arrowScene: PackedScene = preload("res://Scenes/Enemies/ArcherBandit/arrow.tscn")
var isAlive = true


func spawnArrow(playerPosition: Vector2):
	var arrow: Node = arrowScene.instantiate()
	
	arrow.global_position = Vector2(
		playerPosition.x, 
		-50                
	)
	get_parent().add_child(arrow)
