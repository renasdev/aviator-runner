extends KinematicBody2D

var motion = Vector2(0, 0)
var direction = 1

func _ready():
	$AnimationPlayer.play("Run")
	$FloorRayCast2D.add_exception($FrontHitArea2D)
	$FloorRayCast2D.add_exception($HitBoxArea2D)
	$FloorRayCast2D.add_exception($RightRayCast2D)

func _process(_delta):
	if(direction == 1):
		motion.x = min(200, motion.x + 50)
		$Sprite.flip_h = false
		$HitBoxArea2D/CollisionShape2D.position = Vector2(20, -38.5)
		$FrontHitArea2D/CollisionShape2D.position = Vector2(10, -38.5)
		$FloorRayCast2D.set_cast_to(Vector2(20, 50))
	else:
		motion.x = max(-200, motion.x - 50)
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

	if is_colliding_with_tilemap():
		print("there is floor ")
	elif is_on_floor():
		print("jump!!")
		motion.y -= 800
	else:
		print("shit")
		
func is_colliding_with_tilemap():
	var objects_collide = []
	if $FloorRayCast2D.is_colliding():
		print($FloorRayCast2D.get_collider())
		return true
		
	return false

func _on_FrontHitArea2D_body_entered(body):
	if(body.get_name() == GameConstants.PLAYER):
		$AnimationPlayer.play("Simple_Attack")

func _on_HitBoxArea2D_body_entered(body):
	if(body.get_name() == GameConstants.PLAYER):
		body.take_damage()
