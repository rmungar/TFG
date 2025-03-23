extends CanvasLayer

signal loadingScreenFullyCovered

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var progressBar : ProgressBar = $Panel/ProgressBar

func updateProgressBar(newProgress: float) -> void:
	progressBar.set_value_no_signal(newProgress * 100)
	
func startOutroAnimation()-> void:
	await Signal(animationPlayer, "animation_finished")
	animationPlayer.play("endLoad")
	await Signal(animationPlayer, "animation_finished")
	self.queue_free()
