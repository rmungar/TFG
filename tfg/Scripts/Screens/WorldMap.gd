class_name WorldMap extends Node2D

@onready var fadeRect: ColorRect = $CanvasLayer/FadeRect
@onready var player: Player = $Player
var fadeDuration := 4.0
var isFading := false
var fadeDirection := -1 
var fadeTime := 0.0
var deadEnemies: Array = []

func _ready():
	
	if !GameManager.hasLoadedGame:
		player.apply_saved_data(GameManager.temporalPlayerData)
		GameManager.temporalPlayerData = {}  
	else:
		if GameManager.isLoadingGame:
			var data = FileUtils.load_game(GameManager.currentSaveFile)
			if data:
				player.apply_saved_data(data)
				var camera = player.get_node_or_null("Camera2D")
				if player.lastTilemap != "":
					var tilemap = get_node_or_null(player.lastTilemap)
					if tilemap and camera:
						camera.changeRect(tilemap)
	
	$Chest/Sprite2D.flip_h = true
	$Chest2/Sprite2D.flip_h = true
	fadeIn()
	$Portal1/AnimatedSprite2D.play("Warp")
	await $Portal1/AnimatedSprite2D.animation_finished
	$Portal1/AnimatedSprite2D.play("Idle")
	await fadeFinished()
	
	# Espera 2.5 segundos antes de despertar al jugador
	await get_tree().create_timer(2.5).timeout


func _process(delta: float) -> void:
	if player.global_position.x < 0:
		$ParallaxBackground.visible = false
	else:
		if !$ParallaxBackground.visible:
			$ParallaxBackground.visible = true
	
	if isFading:
		fadeTime += delta
		var t: float = clamp(fadeTime / fadeDuration, 0.0, 1.0)
		
		var from = 1.0 if fadeDirection == 1  else 0.0
		var to = 0.0 if fadeDirection == 1 else 1.0
		var alpha: float = lerp(from, to, t)
		
		var color := fadeRect.color
		color.a = alpha
		fadeRect.color = color
		
		if t >= 1.0:
			isFading = false
			if fadeDirection == -1:
				fadeRect.visible = false


func fadeIn():
	fadeDirection = 1
	isFading = true
	fadeTime = 0.0
	fadeRect.visible = true

func fadeOut():
	fadeDirection = -1
	isFading = true
	fadeTime = 0.0
	fadeRect.visible = true

func fadeFinished() -> void:
	while isFading:
		await get_tree().process_frame
	return


func _on_camera_change_boss_body_entered(body: Node2D) -> void:
	if body is Player:
		var camera: PlayerCamera = get_node("Player/Camera2D")
		var background1: TileMapLayer = get_node("FirstZone")
		var background2: TileMapLayer = get_node("BossZone")
		if camera.tileMap.name == "FirstZone":
			camera.changeRect(background2)
		else:
			camera.changeRect(background1)
		respawn_dead_enemies()
		


func _on_camera_change_castle_body_entered(body: Node2D) -> void:
	if body is Player:
		var camera: PlayerCamera = get_node("Player/Camera2D")
		var background1: TileMapLayer = get_node("FirstZone")
		var background2: TileMapLayer = get_node("CastleZone")
		if camera.tileMap.name == "FirstZone":
			camera.changeRect(background2)
		else:
			camera.changeRect(background1)
		respawn_dead_enemies()


func _on_world_collsion_body_entered(body: Node2D) -> void:
	if body is Player:
		body._on_hurtbox_damage_taken(body.MaxHP/5, Vector2(0,0))
		body.teleport(body.lastSafePosition)
	if body is Enemy:
		body.teleport(body.lastSafePosition)
	


func _on_camera_change_camp_body_entered(body: Node2D) -> void:
	if body is Player:
		var camera: PlayerCamera = get_node("Player/Camera2D")
		var background1: TileMapLayer = get_node("Camp")
		var background2: TileMapLayer = get_node("FirstZone")
		if camera.tileMap.name == "Camp":
			camera.changeRect(background2)
		else:
			camera.changeRect(background1)
		respawn_dead_enemies()



func onEnemyDeath(enemyScene: PackedScene, spawnPosition: Vector2):
	deadEnemies.append({"scene" : enemyScene, "pos" : spawnPosition})

func respawn_dead_enemies():
	for info in deadEnemies:
		var new_enemy = info["scene"].instantiate()
		new_enemy.set_deferred("spawnPosition", info["pos"])
		new_enemy.set_deferred("global_position", info["pos"])
		call_deferred("add_child", new_enemy)
		new_enemy.AddToRespawnList.connect(onEnemyDeath)
	deadEnemies.clear()
