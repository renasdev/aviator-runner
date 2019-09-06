extends Node

const UP = Vector2(0, -1)
const GRAVITY = 20
const PLAYER = "Player"

var _camera:Camera2D


func set_current_camera(camera:Camera2D):
	_camera = camera
	
func get_current_camera():
	return _camera