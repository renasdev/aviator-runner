extends Control

onready var gems_label = $VBoxContainer/HBoxContainer/VBoxContainer/GemsLabel
onready var enemies_label = $VBoxContainer/HBoxContainer/VBoxContainer/EnemiesLabel
onready var score_label = $VBoxContainer/ScoreLabel

func _ready():
	$AnimationPlayer.play("show")
	$VBoxContainer.hide()
	
	gems_label.text = tr("gems") + " " + ("%04d" % GameGlobals.current_gems_score)
	enemies_label.text = tr("enemies") + " " + ("%04d" %  GameGlobals.current_enemies_score)
	score_label.text = tr("score") + " " + ("%04d" % GameGlobals.current_score)

func animation_finished():
	if not OS.has_touchscreen_ui_hint():
		$VBoxContainer/ContinueButton.grab_focus()

func _on_ContinueButton_pressed():
	if GameSave.current_state.is_beaten && not GameGlobals.was_last_stage:
		get_tree().change_scene("res://Stages/TitleScreen.tscn")
			
	GameSave.next_phase()
	GameGlobals.current_gems_score = 0
	GameGlobals.current_enemies_score = 0
	GameGlobals.current_score = 0
	
	if not GameGlobals.was_last_stage:
		get_tree().change_scene(GameGlobals.PHASES[GameSave.current_state.next_phase])
	else:
		GameGlobals.was_last_stage = false
		get_tree().change_scene("res://Stages/Credits.tscn")
		
