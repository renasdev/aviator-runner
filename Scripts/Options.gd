extends Control

var supported_locales := {"Português" : "pt_BR", "English" : "en"}

func _ready():
	var volumeDb = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	print(volumeDb)
	var volume = db2linear(volumeDb)
	$VBoxContainer/HSplitContainer/VolumeHSlider.value = volume
	$VBoxContainer/HSplitContainer2/FullscreenCheckBox.pressed = OS.window_fullscreen
	
	var menuButton := $VBoxContainer/HSplitContainer3/MenuButton
	var popup = menuButton.get_popup()
	popup.connect("id_pressed", self, "_on_Language_change")
	
	for locale in supported_locales:
		if supported_locales[locale] == TranslationServer.get_locale():
			menuButton.text = locale
		popup.add_item(locale)
		
func _on_Language_change(id):
	var text = $VBoxContainer/HSplitContainer3/MenuButton.get_popup().get_item_text(id)
	TranslationServer.set_locale(supported_locales[text])
	$VBoxContainer/HSplitContainer3/MenuButton.text = text

func _on_VolumeHSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(value))
	var volumeDb = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	print(value, " ", volumeDb)

func _on_GoBackButton_pressed():
	get_tree().change_scene("res://Stages/TitleScreen.tscn")


func _on_FullscreenCheckBox_pressed():
	OS.window_fullscreen = $VBoxContainer/HSplitContainer2/FullscreenCheckBox.pressed
	
