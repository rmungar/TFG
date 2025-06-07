class_name Tutorial extends Node2D

@onready var fadeRect: ColorRect = $Player/Camera2D/CanvasLayer/FadeRect
@onready var player: Player = $Player
@onready var playerAnimationPlayer: AnimationPlayer = $Player/AnimationPlayer

var fadeDuration := 4.0
var isFading := false
var fadeDirection := -1 
var fadeTime := 0.0

var aliveEnemies = 4
signal tutorialDone()

func _ready():
	AudioManager.play_sound("res://Assets/Sounds/TheCave.mp3", -47.0)
	print(GameManager.hasLoadedGame)
	if GameManager.isLoadingGame:
		var data = FileUtils.load_game(GameManager.currentSaveFile)
		if data:
			player.apply_saved_data(data)
	
	# Empezamos con fade-in (pantalla negra)
	fadeIn()
	await fadeFinished()
	
	# Espera 2.5 segundos antes de despertar al jugador
	await get_tree().create_timer(2.5).timeout
	

func _process(delta: float) -> void:
	
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


func onEnemyDead() -> void:
	
	if aliveEnemies > 0:
		aliveEnemies -= 1
	print(aliveEnemies)
	if aliveEnemies == 0:
		tutorialDone.emit()

func _on_portal_teleport() -> void:
	GameManager.temporalPlayerData = player.serialize()
	GameManager.tutorial_done = true
	print(GameManager.temporalPlayerData)
	fadeOut()
	AudioManager.play_sound("res://Assets/Sounds/teleport.mp3", -40.0)
	$Portal/AnimatedSprite2D.play("Warp")
	await get_tree().create_timer(0.2).timeout
	$Player.visible = false
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://Scenes/Screens/WorldMap.tscn")
