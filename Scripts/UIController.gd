extends CanvasLayer

export var has_visibility_notifier := false

var is_paused := false

func _ready():
	$MobileUI.visible = OS.has_touchscreen_ui_hint()

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_pause"):
		_change_pause_state(!is_paused)
		
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		_change_pause_state(true)
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		_change_pause_state(true)


func _on_ResumeButton_pressed():
	_change_pause_state(false)
	
func _change_pause_state(value: bool):
	if(is_paused == value):
		return
	is_paused = value
	$ControlPause.visible = value
	get_tree().paused = value
	
func _on_MainMenuButton_pressed():
	# Gambiarra para quando a cena tem visibility notifier
	if has_visibility_notifier:
		get_parent().remove_visibility_notifier()
		
	_change_pause_state(false)
	get_tree().change_scene("res://Stages/TitleScreen.tscn")

func _on_PauseButton_pressed():
	_change_pause_state(!is_paused)

func _on_QuitButton_pressed():
	get_tree().quit()
