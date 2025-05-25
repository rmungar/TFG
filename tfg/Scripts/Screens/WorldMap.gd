class_name WorldMap extends Node2D

@onready var fadeRect: ColorRect = $CanvasLayer/FadeRect

var fadeDuration := 4.0
var isFading := false
var fadeDirection := -1 
var fadeTime := 0.0


func _ready():
	# Empezamos con fade-in (pantalla negra)
	fadeIn()
	$Portal1/AnimatedSprite2D.play("Warp")
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
