extends KinematicBody2D

var motion = Vector2(0, 0)

func _ready():
	$AnimationPlayer.play("Run")

func _process(_delta):
	motion.x = min(200, motion.x + 50)
	motion.y += GameConstants.GRAVITY
	motion = move_and_slide(motion, GameConstants.UP)
	
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("Run")

func _on_FrontHitArea2D_body_entered(body):
	$AnimationPlayer.play("Simple_Attack")

func _on_HitBoxArea2D_body_entered(body):
	if(body.get_name() == GameConstants.PLAYER):
		body.take_damage()
