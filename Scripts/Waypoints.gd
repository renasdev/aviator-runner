tool
extends Node2D

class_name Waypoints

export var editor_process: = true setget set_editor_process

export var line_color: = Color(0.228943, 0.710254, 0.945312)
export var line_width: = 10.0
export var triangle_color: = Color(0.722656, 0.908997, 1)

var _active_point_index: = 0
var positions: Array = []

func _init_nodes():
	for node in get_children():
		if node is Position2D:
			positions.append(node)
	
	

func _ready() -> void:
	if !Engine.editor_hint:
		set_process(false)

func _process(_delta: float) -> void:
	update()


func _draw() -> void:
	if not Engine.editor_hint:
		return
	if not positions.size() > 1:
		return
	var points: = PoolVector2Array()
	var triangles: = []
	var last_point: = Vector2.ZERO
	for child in positions:
		points.append(child.position)
		if points.size() > 1:
			var center: Vector2 = (child.position + last_point) / 2
			var angle: = last_point.angle_to_point(child.position)
			triangles.append({center=center, angle=angle})
		last_point = child.position
	points.append(positions[0].position)
	
	draw_polyline(points, line_color, line_width, true)
	for triangle in triangles:
		draw_triangle(triangle['center'], triangle['angle'], line_width * 2.0)


func get_start_position() -> Vector2:
	if(positions.size() <= 0):
		_init_nodes()
	return positions[0].global_position


func get_current_point_position() -> Vector2:
	return positions[_active_point_index].global_position


func get_next_point_position():
	if(positions.size() <= 0):
		_init_nodes()
	_active_point_index = (_active_point_index + 1) % positions.size()
	return get_current_point_position()


func draw_triangle(center:Vector2, angle:float, radius:float) -> void:
	var points: = PoolVector2Array()
	var colors: = PoolColorArray([triangle_color])
	for i in range(3):
		var angle_point: = angle + i * 2.0 * PI / 3.0 + PI
		var offset: = Vector2(radius * cos(angle_point), radius * sin(angle_point))
		var point: = center + offset
		points.append(point)
	draw_polygon(points, colors)
	
func set_editor_process(value:bool) -> void:
	editor_process = value
	if not Engine.editor_hint:
		return
	set_process(value)
	
	
func _get_configuration_warning():
	_init_nodes()
	var warning = ""
	
	if positions.size() == 0:
		warning = "This node need more positions"
			
	return warning
