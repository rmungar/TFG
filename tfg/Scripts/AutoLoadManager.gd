extends Node

signal progressChanged(progress)
signal loadDone

var loadScreenPath: String = "res://Scenes/LoadingScreen.tscn"
var loadScreen = load(loadScreenPath)
var loadedResource: PackedScene
var _scenePath: String
var progress: Array = []

var useVariousThreads: bool = true


func loadScene(scenePath: String) -> void:
	_scenePath = scenePath
	
	var newLoadingScreen = loadScreen.instantiate()
	get_tree().get_root().add_child(newLoadingScreen)
	
	self.progressChanged.connect(newLoadingScreen.updateProgressBar)
	self.loadDone.connect(newLoadingScreen.startOutroAnimation)
	
	await Signal(newLoadingScreen, "loadingScreenFullyCovered")
	
	startLoad()
	
	
func startLoad()-> void:
	var state = ResourceLoader.load_threaded_request(_scenePath, "", useVariousThreads)
	if state == OK:
		set_process(true)


func _process(_delta):
	var loadStatus = ResourceLoader.load_threaded_get_status(_scenePath, progress)
	match loadStatus:
		0, 2: #? THREAD_LOAD_INVALID_RESOURCES, THREAD_LOAD_FAILED
			set_process(false)
			return
		1: #? THREAD_LOAD_IN_PROGRESS
			emit_signal("progressChanged", progress[0])
		3: #? THREAD_LOAD_LOADED
			loadedResource = ResourceLoader.load_threaded_get(_scenePath)
			emit_signal("progressChanged", progress[0])
			emit_signal("loadDone")
			get_tree().change_scene_to_packed(loadedResource)
