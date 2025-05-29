extends Node


func saveGame(saveFile: int, player: Player):
	
	
	var playerData: Dictionary = {
		HP = player.HP,
		canHeal = player.canHeal,
		canAttack = player.canAttack,
		lasCheckPoint = player.lastCheckPoint,
		inventory = player.inventory,
		money = player.money
	}
	
	
	var dataJSON = JSON.stringify(playerData)
	
	match saveFile:
		1: 
			var file = FileAccess.open("user://gamefile1.save", FileAccess.WRITE)
			file.store_line(dataJSON)
		2: 
			var file = FileAccess.open("user://gamefile2.save", FileAccess.WRITE)
			file.store_line(dataJSON)
		3: 
			var file = FileAccess.open("user://gamefile3.save", FileAccess.WRITE)
			file.store_line(dataJSON)
		4: 
			var file = FileAccess.open("user://gamefile4.save", FileAccess.WRITE)
			file.store_line(dataJSON)


func loadGame():
	pass
