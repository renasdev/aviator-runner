extends Control

onready var gems_label = $VBoxContainer/HBoxContainer/VBoxContainer/GemsLabel
onready var enemies_label = $VBoxContainer/HBoxContainer/VBoxContainer/EnemiesLabel
onready var score_label = $VBoxContainer/ScoreLabel

func _ready():
	$AnimationPlayer.play("show")
	
	gems_label.text = tr("gems") + " " + ("%04d" % GameSave.current_gems_score)
	enemies_label.text = tr("enemies") + " " + ("%04d" %  GameSave.current_enemies_score)
	score_label.text = tr("score") + " " + ("%04d" % GameSave.current_score)


func _on_ContinueButton_pressed():
	GameSave.next_phase()
	GameSave.current_gems_score = 0
	GameSave.current_enemies_score = 0
	GameSave.current_score = 0
	get_tree().change_scene(GameGlobals.PHASES[GameSave.current_state.next_phase])
