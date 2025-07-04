extends Node

@export var initial_pool_size: int = 3
@export var max_idle_time: float = 5.0 

class PlayerEntry:
	var player: AudioStreamPlayer
	var last_play_time: float

var pool: Array[PlayerEntry] = []


var musicPlayer: AudioStreamPlayer
var musicTracks: Array[String] = ["res://Assets/Sounds/EchoesFromTheFutureV1.mp3","res://Assets/Sounds/EchoesFromTheFutureV2.mp3"]
var mainMenuMusicTracks: Array[String] = ["res://Assets/Sounds/EchoesFromTheFutureV1.mp3","res://Assets/Sounds/EchoesFromTheFutureV2.mp3"]
var currentTrackIndex: int = 0


var taggedPlayers: Dictionary = {}

func _ready():
	for i in initial_pool_size:
		var player = AudioStreamPlayer.new()
		add_child(player)
		pool.append(PlayerEntry.new())
		pool[i].player = player
		pool[i].last_play_time = 0.0


	musicPlayer = AudioStreamPlayer.new()
	add_child(musicPlayer)
	musicPlayer.bus = "Music"  
	musicPlayer.connect("finished", Callable(self, "_on_music_finished"))

func _process(delta):
	var current_time = Time.get_ticks_msec() / 1000.0
	for entry in pool.duplicate():
		if not entry.player.playing and current_time - entry.last_play_time > max_idle_time and pool.size() > initial_pool_size:
			entry.player.queue_free()
			pool.erase(entry)


func play_sound(sound_path: String, volume_db: float = 0.0):
	var sound = load(sound_path)
	if not sound:
		push_error("No se pudo cargar el sonido: " + sound_path)
		return

	var player_entry = _get_available_player()
	player_entry.player.stop()
	player_entry.player.stream = sound
	player_entry.player.volume_db = volume_db
	player_entry.player.play()
	player_entry.last_play_time = Time.get_ticks_msec() / 1000.0

func play_tagged_sound(tag: String, sound_path: String, volume_db: float = 0.0):
	var sound = load(sound_path)
	if not sound:
		push_error("No se pudo cargar el sonido: " + sound_path)
		return

	if taggedPlayers.has(tag):
		var current_player: AudioStreamPlayer = taggedPlayers[tag]
		if current_player.playing and current_player.stream.resource_path == sound.resource_path:
			return  

		current_player.stop()
		taggedPlayers.erase(tag)

	var player_entry = _get_available_player()
	player_entry.player.stop()
	player_entry.player.stream = sound
	player_entry.player.volume_db = volume_db
	player_entry.player.play()
	player_entry.last_play_time = Time.get_ticks_msec() / 1000.0

	taggedPlayers[tag] = player_entry.player


func stop_tagged_sound(tag: String):
	if taggedPlayers.has(tag):
		var player: AudioStreamPlayer = taggedPlayers[tag]
		player.stop()
		taggedPlayers.erase(tag)

func _get_available_player() -> PlayerEntry:
	for entry in pool:
		if not entry.player.playing:
			return entry

	var new_player = AudioStreamPlayer.new()
	add_child(new_player)
	var new_entry = PlayerEntry.new()
	new_entry.player = new_player
	new_entry.last_play_time = 0.0
	pool.append(new_entry)
	return new_entry


func cycle_music(tracks: Array[String] = mainMenuMusicTracks):
	musicTracks = tracks
	currentTrackIndex = 0
	_play_current_track()

func _play_current_track():
	if musicTracks.is_empty():

		return
	var path = musicTracks[currentTrackIndex]
	var stream = load(path)
	if stream:
		musicPlayer.stream = stream
		musicPlayer.volume_db = -30.0
		musicPlayer.play()
	else:
		push_error("No se pudo cargar la pista: " + path)

func _on_music_finished():
	currentTrackIndex = (currentTrackIndex + 1) % musicTracks.size()
	_play_current_track()

func stop_music():
	if musicPlayer.playing:
		musicPlayer.stop()
	musicTracks.clear()
	musicTracks = mainMenuMusicTracks
	currentTrackIndex = 0

func play_music_once(path: String):
	stop_music()
	var stream = load(path)
	if stream:
		musicPlayer.stream = stream
		musicPlayer.play()
	else:
		push_error("No se pudo cargar la música: " + path)
