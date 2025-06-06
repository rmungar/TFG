extends CanvasLayer

var targetScene: String

func _ready():
	
	AudioManager.stop_music()
	
	var animation = randi_range(1,3)
	var animationName = "default" + str(animation)
	$Panel/AnimatedSprite2D.play(animationName)
	
	await $AnimationPlayer.animation_finished
	
	
	await get_tree().create_timer(1.0).timeout
	
	$AnimationPlayer.play("endLoad")
	
	get_tree().change_scene_to_file(targetScene)
