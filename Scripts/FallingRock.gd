extends KinematicBody2D

const FALLING_SPEED := 1

var falling := false
var motion := Vector2(0, 0)

onready var initial_pos = position

func _ready():
	pass # Replace with function body.

func _process(delta):
	if falling:
		motion.y -= -FALLING_SPEED
		motion.x = 0
		var collision = move_and_collide(motion)
		
		if collision and collision.get_collider().get_name() == GameConstants.PLAYER:
			collision.get_collider().take_damage()
			

func _draw() -> void:
	set_as_toplevel(true)
	var shape: = $CollisionShape2D
	var extents: Vector2 = shape.shape.extents * 2.0
	var rect: = Rect2(shape.position - extents / 2.0, extents)
	draw_rect(rect, Color('fff'))

func _on_Area2D_body_entered(body):
	if(body.get_name() == GameConstants.PLAYER):
		falling = true
