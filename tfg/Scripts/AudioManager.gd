extends Node

@export var initial_pool_size: int = 3
@export var max_idle_time: float = 10.0  # segundos para liberar AudioStreamPlayer inactivo

class PlayerEntry:
	var player: AudioStreamPlayer
	var last_play_time: float

var pool: Array[PlayerEntry] = []

func _ready():
	for i in initial_pool_size:
		var player = AudioStreamPlayer.new()
		add_child(player)
		pool.append(PlayerEntry.new())
		pool[i].player = player
		pool[i].last_play_time = 0.0

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

func _get_available_player() -> PlayerEntry:
	for entry in pool:
		if not entry.player.playing:
			return entry
	
	# Si no hay libre, crea uno nuevo y lo añade al pool
	var new_player = AudioStreamPlayer.new()
	add_child(new_player)
	var new_entry = PlayerEntry.new()
	new_entry.player = new_player
	new_entry.last_play_time = 0.0
	pool.append(new_entry)
	return new_entry

func _process(delta):
	var current_time = Time.get_ticks_msec() / 1000.0
	for entry in pool.duplicate():
		# Si lleva más de max_idle_time sin reproducir y pool es mayor que inicial, eliminar
		if not entry.player.playing and current_time - entry.last_play_time > max_idle_time and pool.size() > initial_pool_size:
			entry.player.queue_free()
			pool.erase(entry)
