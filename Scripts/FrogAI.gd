extends KinematicBody2D

const SPEED = 100

export(String, FILE, "*.tscn,*.scn") var explosion_path

var target:KinematicBody2D
var movement = Vector2(0,0)

func _physics_process(delta):
	movement.y += 20
	if target:
		var direction = (target.get_position() - position).normalized()
		var motion = direction * SPEED
		movement.x = motion.x
		
	movement = move_and_slide(movement, Vector2(0, -1))
	$AnimatedSprite.set_flip_h(movement.x < 0)
	
func _on_FieldOfView_body_entered(body):	
	if(body.get_name() == "Player"):
		target = body

func _on_BodyArea_body_entered(body):
	if(body.get_name() == GameConstants.PLAYER):
		var direction = (body.get_position() - position).normalized()
		
		print(direction)
		
		#Body is comming from above
		if(direction.y < -0.6):
			var scene = load(explosion_path)
			var scene_instance = scene.instance()
			scene_instance.set_name(name + "_animation")
			scene_instance.position = position
			get_parent().add_child(scene_instance)
			body.bounce(-500)
			self.queue_free()
		else: #Body come by the sides
			$AudioStreamPlayer2D.play(0.0)
			$Timer.start(0.5)


func _on_Timer_timeout():
	target.kill()
