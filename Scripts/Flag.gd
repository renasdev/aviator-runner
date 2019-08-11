tool
extends Node2D

export(String, FILE, "*.tscn,*.scn") var next_scene_path

onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.connect("timeout", self, "next_scene")
	timer.set_wait_time( 1 )

func _on_Area2D_body_entered(body):
	if(body.get_name() == GameConstants.PLAYER):
		$AudioStreamPlayer2D.play(0.0)
		timer.start()
		
#warning-ignore:return_value_discarded
func next_scene():
	get_tree().change_scene(next_scene_path)
	
	
func _get_configuration_warning():
	var warning = ""
	
	if not next_scene_path:
		warning = "Next scene is mandatory, please fill up"
	
	return warning