tool
extends Node2D

export(String, FILE, "*.tscn,*.scn") var next_scene_path

onready var timer = $Timer
var has_touched := false
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.connect("timeout", self, "go_to_score")
	timer.set_wait_time( 2 )
	$CPUParticles2D.emitting = false

func _on_Area2D_body_entered(body):
	if(!has_touched && body.get_name() == GameGlobals.PLAYER):
		has_touched = true
		$CPUParticles2D.emitting = true
		$AudioStreamPlayer2D.play(0.0)
		timer.start()
		player = body
		
#warning-ignore:return_value_discarded
func go_to_score():
	GameGlobals.current_gems_score = player.gems_counter
	GameGlobals.current_enemies_score = player.enemy_counter
	GameGlobals.current_score = player.score
	get_tree().change_scene("res://Stages/Score.tscn")
	
	
func _get_configuration_warning():
	var warning = ""
	
	if not next_scene_path:
		warning = "Next scene is mandatory, please fill up"
	
	return warning
