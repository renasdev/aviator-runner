extends Node

const SAVE_FILE = "user://savegame.save"

var initial_save_date := {
	"options" : {
		"volume" : 20,
		"fullscreen": true,
		"language": null
	},
	"next_phase" : 1
}

var current_state := {}

func save_game():
	_set_options_to_State()
	var save_game = File.new()
	save_game.open(SAVE_FILE, File.WRITE)
	save_game.store_string(to_json(current_state))
	save_game.close()
	
func load_game():
	_load_state()
	
	OS.window_fullscreen = current_state.options.fullscreen
	TranslationServer.set_locale(current_state.options.language)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(current_state.options.volume))
	
func _set_options_to_State():
	current_state.options.fullscreen = OS.window_fullscreen
	current_state.options.language = TranslationServer.get_locale()
	var volumeDb = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	current_state.options.volume = db2linear(volumeDb)
	
func _load_state():
	var save_game = File.new()
	if not save_game.file_exists(SAVE_FILE):
		current_state = initial_save_date
		current_state.options.language = TranslationServer.get_locale()
		return
	
	save_game.open(SAVE_FILE, File.READ)
	var state_json = save_game.get_as_text()
	var state = parse_json(state_json)
	current_state = state
	save_game.close()
	
func _ready():
	print("Loading game state ", OS.get_user_data_dir())
	load_game()
	print(current_state)
	
