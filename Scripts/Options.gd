extends Control

onready var volume_slider := $VBoxContainer/VolumeContainer/VolumeHSlider
onready var full_screen_checkbox := $VBoxContainer/FullScreenContainer/FullscreenCheckBox
onready var language_menu_button := $VBoxContainer/LanguageContainer/MenuButton

var supported_locales := {"Português" : "pt_BR", "English" : "en"}

func _ready():
	var volumeDb = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	var volume = db2linear(volumeDb)
	volume_slider.value = volume
	full_screen_checkbox.pressed = OS.window_fullscreen
	
	var popup = language_menu_button.get_popup()
	popup.connect("id_pressed", self, "_on_Language_change")
	
	for locale in supported_locales:
		if supported_locales[locale] == TranslationServer.get_locale():
			language_menu_button.text = locale
		popup.add_item(locale)
		
func _on_Language_change(id):
	var text = language_menu_button.get_popup().get_item_text(id)
	TranslationServer.set_locale(supported_locales[text])
	language_menu_button.text = text
	GameSave.save_game()

func _on_VolumeHSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(value))
	var volumeDb = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	print(value, " ", volumeDb)
	GameSave.save_game()

func _on_FullscreenCheckBox_pressed():
	OS.window_fullscreen = full_screen_checkbox.pressed
	GameSave.save_game()
	

func _on_GoBackButton_pressed():
	GameSave.save_game()
	get_tree().change_scene("res://Stages/TitleScreen.tscn")
	
