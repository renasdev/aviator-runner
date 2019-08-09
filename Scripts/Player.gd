extends KinematicBody2D

const MAX_SPEED = 400
const JUMP_HEIGHT = 650
var motion = Vector2()

func _physics_process(delta):
	motion.y += GameConstants.GRAVITY
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
			
	$AnimatedSprite.play(animation)
	
	motion = move_and_slide(motion, GameConstants.UP)
	
	# Player is falling non stop
	if motion.y > 900 and motion.y < 2000 and !$SFX/Falling.is_playing() :
		$SFX/Falling.play(0.0)
		pass
	if motion.y > 2500:
		kill()
		
func kill():
	get_tree().reload_current_scene()
	
func bounce(force:float):
	motion.y += force