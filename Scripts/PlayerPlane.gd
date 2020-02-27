extends KinematicBody2D

const MAX_H_SPEED = 400
const MAX_H_AUTO_SPEED = 300
const MAX_V_SPEED = 400

var motion := Vector2(0, 0)
var score := 0
var finished := false

var gems_counter := 0
var enemy_counter := 0

func _ready():
	pass

func _physics_process(_delta):
	var has_player_input := false
	
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + 50, MAX_H_SPEED * 1.5)
		has_player_input = true
	elif Input.is_action_pressed("ui_left"):
		motion.x = -20
		has_player_input = true
		
	if Input.is_action_pressed("ui_up"):
		motion.y = max(motion.y - 50, -MAX_V_SPEED)
		has_player_input = true
	elif Input.is_action_pressed("ui_down"):
		motion.y = min(motion.y + 50, MAX_V_SPEED)
		has_player_input = true
	if !has_player_input:
		motion.x = min(motion.x + 10, MAX_H_AUTO_SPEED)
		motion.y = 0
	
	motion = move_and_slide(motion, GameGlobals.UP)
	
func take_damage():
	_kill()
	
# Keep same contract as the player
func bounce(_value):
	take_damage()
	
func increment_gems(amount:int, is_enemy:bool = false):
	score += amount
	$UI/ControlUI/HBoxContainer/GemsCounter.text = "%04d" % score
	
	if is_enemy:
		enemy_counter += 1
	else:
		gems_counter += 1
	
func instant_kill():
	_kill()
	
func _kill():
	if !finished:
		get_tree().reload_current_scene()

func remove_visibility_notifier():
	remove_child($VisibilityNotifier2D)
	
func _on_VisibilityNotifier2D_screen_exited():
	take_damage()
	
	
func _on_RigidBody2D_body_entered(body):
	if(GameGlobals.is_player(body)):
		print("Finished ", body.get_name())
		print("Going to credits")
		finished = true
		$FinishingTimer.start(0)
	
func _on_FinishingTimer_timeout():
	GameSave.beat_game()
	GameGlobals.was_last_stage = true
	get_tree().change_scene("res://Stages/Score.tscn")
