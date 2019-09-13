extends Control

func _ready():
	pass

func _on_GoBack_pressed():
	get_tree().change_scene("res://Stages/TitleScreen.tscn")
	
func _on_Button_pressed():
	get_tree().change_scene("res://Stages/cena1.tscn")

func _on_Button2_pressed():
	get_tree().change_scene("res://Stages/cena2.tscn")

func _on_Button3_pressed():
	get_tree().change_scene("res://Stages/cena3.tscn")
	
func _on_Button4_pressed():
	get_tree().change_scene("res://Stages/cena4.tscn")

func _on_Button5_pressed():
	get_tree().change_scene("res://Stages/PlaneTest.tscn")
