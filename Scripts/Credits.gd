extends Control

func _ready():
	var credits_text = load_file("res://credits.tres")
	$VBoxContainer/Label.text = credits_text
	pass


func load_file(filename):
	var result = ""
	var f = File.new()
	f.open(filename, 1)
	var index = 1
	while not f.eof_reached():
		var line = f.get_line()
		##result[str(index)] = line
		result = str(result, "\n", line)
		index += 1
	f.close()
	return result
	



func _on_Button_pressed():
	get_tree().change_scene("res://Stages/TitleScreen.tscn")

