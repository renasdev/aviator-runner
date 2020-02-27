extends KinematicBody2D

const MAX_SPEED = 400
const JUMP_HEIGHT = 650
const MAX_HEIGHT = 750

export var auto_kill_on_falling := true

var motion = Vector2()
var score := 0
var dying := false

var gems_counter := 0
var enemy_counter := 0

func _ready():
	$AnimatedSprite.play("Idle")

func _process_input():
	if dying:
		motion.x = 0
		return "Idle"
		
	var animation = "Idle"
	
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + 50, MAX_SPEED)
		$AnimatedSprite.set_flip_h(false)
		animation = "Run"
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - 50, -MAX_SPEED)
		$AnimatedSprite.set_flip_h(true)
		animation = "Run"
	else:
		motion.x = 0
		
	if is_on_floor():
		$SFX/Falling.stop()
		if Input.is_action_pressed("ui_jump"):
			motion.y -= JUMP_HEIGHT
			$SFX/Jump.play(0.0)
	else:
		if motion.y < 0:
			animation = "Jump"
		else:
			animation = "Fall"
			
	if Input.is_action_pressed("reload"):
		instant_kill()
			
	return animation
		

func _physics_process(_delta):
	motion.y += GameGlobals.GRAVITY
		
	var animation = _process_input()
			
	$AnimatedSprite.play(animation)

	
	if(motion.y < -MAX_HEIGHT):
		motion.y = -MAX_HEIGHT
	
	motion = move_and_slide(motion, GameGlobals.UP)
	
	# Player is falling non stop
	if motion.y > 900 and motion.y < 2000 and !$SFX/Falling.is_playing() :
		$SFX/Falling.play(0.0)
	if auto_kill_on_falling && motion.y > 2500:
		instant_kill()
		
#warning-ignore:return_value_discarded
func _kill():
	get_tree().reload_current_scene()
	
func _on_KillerTimer_timeout():
	_kill()
	
func take_damage():
	if not dying:
		dying = true
		$KillerTimer.start(0.5)
		$AnimationPlayer.play("damage")
		if !$SFX/Damage.is_playing():
			$SFX/Damage.play()
	
func instant_kill():
	if not dying:
		dying = true
		$AnimationPlayer.play("damage")
		if !$SFX/Damage.is_playing():
			$SFX/Damage.play()
		$KillerTimer.start(0.1)
	
	
func increment_gems(amount:int, is_enemy:bool = true):
	score += amount
	$UI/ControlUI/HBoxContainer/GemsCounter.text = "%04d" % score
	
	if is_enemy:
		enemy_counter += 1
	else:
		gems_counter += 1
	
func bounce(force:float):
	motion.y += force
