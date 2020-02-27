extends Control

export(String, FILE, "*.tscn,*.scn") var chose_stage_scene
export(String, FILE, "*.tscn,*.scn") var touch_controls_scene
export(String, FILE, "*.tscn,*.scn") var options_scene
export(String, FILE, "*.tscn,*.scn") var credits_scene

onready var next_phase = GameSave.current_state.next_phase

func _ready():
	print("TitleScreen")
	
	if next_phase >= GameGlobals.get_number_of_phases():
		print("Reseting next phase")
		GameSave.reset_next_phase()
		next_phase = 0
	
	if next_phase > 0:
		$VBoxContainer/HBoxContainer/VBoxContainer/NewGame.text = 'resume'
		
	if not GameSave.current_state.is_beaten:
		$VBoxContainer/HBoxContainer/VBoxContainer/ChoseStage.hide()
#		$VBoxContainer/HBoxContainer/VBoxContainer/ChoseStage.disabled = true
	
	if OS.has_touchscreen_ui_hint() || OS.get_name() == "HTML5":
		$VBoxContainer/HBoxContainer/VBoxContainer/Quit.hide()
	
#warning-ignore:return_value_discarded
func _on_NewGame_pressed():
	if next_phase == 0 && OS.has_touchscreen_ui_hint():
		get_tree().change_scene(touch_controls_scene)
	else:
		get_tree().change_scene(GameGlobals.PHASES[next_phase])

#warning-ignore:return_value_discarded
func _on_ChoseStage_pressed():
	get_tree().change_scene(chose_stage_scene)

func _on_Options_pressed():
	get_tree().change_scene(options_scene)

func _on_Credits_pressed():
	get_tree().change_scene(credits_scene)
	
func _on_Quit_pressed():
	get_tree().quit()
