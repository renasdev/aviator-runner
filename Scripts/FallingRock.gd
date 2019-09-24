extends KinematicBody2D

const FALLING_SPEED := 1

var falling := false
var motion := Vector2(0, 0)
var is_colliding := false

onready var initial_pos = position

func _ready():
	pass

func _process(delta):
	if falling:
		motion.y -= -FALLING_SPEED
		motion.x = 0
		var collision = move_and_collide(motion)
		
		if collision and collision.get_collider().get_name() == GameGlobals.PLAYER:
			collision.get_collider().take_damage()
		elif !is_colliding and collision:
			$AudioStreamPlayer2D.play(0.0)
			is_colliding = true
			

func _draw() -> void:
	set_as_toplevel(true)
	var shape: = $CollisionShape2D
	var extents: Vector2 = shape.shape.extents * 2.0
	var rect: = Rect2(shape.position - extents / 2.0, extents)
	draw_rect(rect, Color('fff'))

func _on_Area2D_body_entered(body):
	if(body.get_name() == GameGlobals.PLAYER):
		falling = true
