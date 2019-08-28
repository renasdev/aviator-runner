extends Control

export(String, FILE, "*.tscn,*.scn") var new_game_scene
export(String, FILE, "*.tscn,*.scn") var chose_stage_scene
export(String, FILE, "*.tscn,*.scn") var credits_scene


func _ready():
	pass

#warning-ignore:return_value_discarded
func _on_NewGame_pressed():
	get_tree().change_scene(new_game_scene)

#warning-ignore:return_value_discarded
func _on_ChoseStage_pressed():
	get_tree().change_scene(chose_stage_scene)


func _on_Credits_pressed():
	get_tree().change_scene(credits_scene)
