extends Control

func _ready():
	var volumeDb = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	print(volumeDb)
	var volume = db2linear(volumeDb)
	$VBoxContainer/HSplitContainer/VolumeHSlider.value = volume

func _on_VolumeHSlider_value_changed(value):
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(value))
	var volumeDb = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	print(value, " ", volumeDb)

func _on_GoBackButton_pressed():
	get_tree().change_scene("res://Stages/TitleScreen.tscn")
