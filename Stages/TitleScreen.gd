extends Control

export(String, FILE, "*.tscn,*.scn") var new_game_scene
export(String, FILE, "*.tscn,*.scn") var chose_stage_scene

func _ready():
	pass


func _on_NewGame_pressed():
	get_tree().change_scene(new_game_scene)


func _on_ChoseStage_pressed():
	get_tree().change_scene(chose_stage_scene)
