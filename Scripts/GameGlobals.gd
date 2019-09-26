extends Node

const UP = Vector2(0, -1)
const GRAVITY = 20
const PLAYER = "Player"
const PHASES = ["res://Stages/cena1.tscn",
				"res://Stages/cena2.tscn",
				"res://Stages/cena3.tscn",
				"res://Stages/cena4.tscn",
				"res://Stages/PlaneTest.tscn"]

var _camera:Camera2D

func is_player(obj: Node2D):
	return obj.get_name() == "Player" || obj.get_name() == "PlayerPlane"

func set_current_camera(camera:Camera2D):
	_camera = camera

func get_current_camera():
	return _camera
	
func get_number_of_phases():
	return PHASES.size()