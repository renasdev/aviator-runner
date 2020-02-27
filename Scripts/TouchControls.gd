extends Control

export(String, FILE, "*.tscn,*.scn") var back_scene

onready var next_phase = GameSave.current_state.next_phase

func _on_GotItButton_pressed():
	get_tree().change_scene(GameGlobals.PHASES[next_phase])

func _on_BackButton_pressed():
	get_tree().change_scene(back_scene)



