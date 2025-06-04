extends HTTPRequest


const APIURL = "https://tfgapi-snlc.onrender.com"

signal requestCompleted(success: bool, result)

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	request_completed.connect(_on_request_completed)


func _send_request(method: HTTPClient.Method, endpoint: String, data = null):
	print("Data: ",data)
	var url = APIURL + endpoint
	print(url)
	var body = JSON.stringify(data) if data != null else ""
	var headers = ["Content-Type: application/json"]
	if method in [HTTPClient.METHOD_POST, HTTPClient.METHOD_PUT]:
		request(url, headers, method, body)
	else:
		request(url, headers, method)
		
	await request_completed


func _on_request_completed(result, response_code, headers, body):
	if response_code == 200 or response_code == 201:
		var text = body.get_string_from_utf8()
		print("Texto recibido: ", text)
		
		var json = JSON.parse_string(text)
		if json is Dictionary or json is Array:
			requestCompleted.emit(true, json)
		else:
			print("Respuesta JSON no válida: no es ni un diccionario ni un array")
			requestCompleted.emit(false, null)
	else:
		var text = body.get_string_from_utf8()
		print("Error en API: código %s " % response_code, text)
		requestCompleted.emit(false, null)


func get_all_players():
	_send_request(HTTPClient.METHOD_GET, "/api/PlayerInfo")

func get_player_by_id():
	_send_request(HTTPClient.METHOD_GET, "/api/PlayerInfo/%s" % GameManager.currentSaveFile)

func create_player():
	var playerData: Dictionary = {
		"PlayerId" : str(GameManager.currentSaveFile),
		"TotalPlayTime" : GameManager.totalPlayTime,
		"LastSession": Time.get_datetime_string_from_unix_time(Time.get_unix_time_from_system()) + "Z"
	}
	_send_request(HTTPClient.METHOD_POST, "/api/PlayerInfo", playerData)

func update_player():
	var playerData: Dictionary = {
		"updatedPlayerInfo": {
			"PlayerId" : str(GameManager.currentSaveFile),
			"TotalPlayTime" : GameManager.totalPlayTime,
			"LastSession": Time.get_datetime_string_from_unix_time(Time.get_unix_time_from_system()) + "Z"
		}
	}
	_send_request(HTTPClient.METHOD_PUT, "/api/PlayerInfo/%s" % GameManager.currentSaveFile, playerData)

func delete_player(id: int):
	_send_request(HTTPClient.METHOD_DELETE, "/api/PlayerInfo/%s" % id)
