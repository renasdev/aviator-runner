extends KinematicBody2D

const MAX_SPEED = 350

var motion = Vector2(0, 0)
var direction = 1
var is_jumping := false

func _ready():
	$AnimationPlayer.play("Run")
	$FloorRayCast2D.add_exception($FrontHitArea2D)
	$FloorRayCast2D.add_exception($HitBoxArea2D)
	$FloorRayCast2D.add_exception($RightRayCast2D)

func _process(_delta):
	if(direction == 1):
		motion.x = min(MAX_SPEED, motion.x + 50)
		$Sprite.flip_h = false
		$HitBoxArea2D/CollisionShape2D.position = Vector2(20, -38.5)
		$FrontHitArea2D/CollisionShape2D.position = Vector2(10, -38.5)
		$FloorRayCast2D.set_cast_to(Vector2(20, 50))
	else:
		motion.x = max(-MAX_SPEED, motion.x - 50)
		$Sprite.flip_h = true
		$HitBoxArea2D/CollisionShape2D.position = Vector2(-80, -38.5)
		$FrontHitArea2D/CollisionShape2D.position = Vector2(-90, -38.5)
		$FloorRayCast2D.set_cast_to(Vector2(-100, 50))
		
	motion.y += GameConstants.GRAVITY
	motion = move_and_slide(motion, GameConstants.UP)
	
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("Run")
		
	if $RightRayCast2D.is_colliding() && $RightRayCast2D.get_collider().get_name() == GameConstants.PLAYER:
		direction = 1
	elif $LeftRayCast2D.is_colliding() && $LeftRayCast2D.get_collider().get_name() == GameConstants.PLAYER:
		direction = -1
		
	if is_on_floor() && is_jumping:
		is_jumping = false
		GameConstants.get_current_camera().shake(3.0, 0.5)
		$ImpactAudioStreamPlayer2D.play(0.0)

	if is_colliding_with_tilemap():
		"""there is floor ahead"""
		pass
	elif is_on_floor():
		"""JUMP"""
		is_jumping = true
		motion.y -= 800
		
func is_colliding_with_tilemap():
	var objects_collide = []
	if $FloorRayCast2D.is_colliding():
		# print($FloorRayCast2D.get_collider())
		return true
		
	return false

func _on_FrontHitArea2D_body_entered(body):
	if(body.get_name() == GameConstants.PLAYER):
		$AnimationPlayer.play("Simple_Attack")

func _on_HitBoxArea2D_body_entered(body):
	if(body.get_name() == GameConstants.PLAYER):
		body.take_damage()