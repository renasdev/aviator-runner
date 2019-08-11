"""Moving platform, moves to target positions given by the Waypoints node"""
tool
extends KinematicBody2D

onready var wait_timer: Timer = $Timer
onready var waypoints: = get_parent()

export var editor_process: = true setget set_editor_process
export var speed: = 400.0

var target_position: = Vector2()

func _ready() -> void:	
	if not waypoints or not is_node_ok():
		set_physics_process(false)
		return
		
	if not name == "MovingPlatform":
		set_process(false)
		set_physics_process(false)	
		
	set_as_toplevel(true)
	set_physics_process(false)
	position = waypoints.get_start_position()
	target_position = waypoints.get_next_point_position()
	wait_timer.start()


func _physics_process(delta: float) -> void:
	var direction: = (target_position - position).normalized()
	var motion: = direction * speed * delta
	var distance_to_target: = position.distance_to(target_position)
	if motion.length() > distance_to_target:
		position = target_position
		target_position = waypoints.get_next_point_position()
		set_physics_process(false)
		wait_timer.start()
	else:
		position += motion


func _draw() -> void:
	set_as_toplevel(true)
	var shape: = $CollisionShape2D
	var extents: Vector2 = shape.shape.extents * 2.0
	var rect: = Rect2(shape.position - extents / 2.0, extents)
	draw_rect(rect, Color('fff'))


func set_editor_process(value:bool) -> void:
	editor_process = value
	if not Engine.editor_hint:
		return
	set_physics_process(value)


func _on_Timer_timeout() -> void:
	set_physics_process(true)
	
func is_node_ok():
	if not get_parent() or not get_parent().get_script():
		return false
	else:
		return "Waypoints" in get_parent().get_script().get_path()
	
	
func _get_configuration_warning():
	var warning = ""
	
	if not is_node_ok():
		warning = "This node need to be a child of the Waypoints"
			
	return warning
