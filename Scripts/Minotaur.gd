extends KinematicBody2D

var motion = Vector2(0, 0)
var direction = 1

func _ready():
	$AnimationPlayer.play("Run")

func _process(_delta):
	if(direction == 1):
		motion.x = min(200, motion.x + 50)
		$Sprite.flip_h = false
		$HitBoxArea2D/CollisionShape2D.position = Vector2(20, -38.5)
		$FrontHitArea2D/CollisionShape2D.position = Vector2(10, -38.5)
	else:
		motion.x = max(-200, motion.x - 50)
		$Sprite.flip_h = true
		$HitBoxArea2D/CollisionShape2D.position = Vector2(-80, -38.5)
		$FrontHitArea2D/CollisionShape2D.position = Vector2(-90, -38.5)
		
	motion.y += GameConstants.GRAVITY
	print(motion)
	motion = move_and_slide(motion, GameConstants.UP)
	
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("Run")
		
	if $RightRayCast2D.is_colliding() && $RightRayCast2D.get_collider().get_name() == GameConstants.PLAYER:
		direction = 1
	elif $LeftRayCast2D.is_colliding() && $LeftRayCast2D.get_collider().get_name() == GameConstants.PLAYER:
		direction = -1


func _on_FrontHitArea2D_body_entered(body):
	$AnimationPlayer.play("Simple_Attack")

func _on_HitBoxArea2D_body_entered(body):
	if(body.get_name() == GameConstants.PLAYER):
		body.take_damage()
