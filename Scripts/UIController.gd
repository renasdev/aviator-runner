extends CanvasLayer

var is_paused := false

func _ready():
	pass

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_pause"):
		_change_pause_state(!is_paused)

func _on_ResumeButton_pressed():
	_change_pause_state(false)
	
func _change_pause_state(value: bool):
	is_paused = value
	$ControlPause.visible = value
	get_tree().paused = value
	
func _on_MainMenuButton_pressed():
	_change_pause_state(false)
	get_tree().change_scene("res://Stages/TitleScreen.tscn")
