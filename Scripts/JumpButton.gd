extends Node2D

const INACTIVE_IDX = -1;
export var isDynamicallyShowing := true
export var isSingleHand = false

onready var bg := $bg
onready var animation_player := $AnimationPlayer

var centerPoint = Vector2(0,0)
var halfSize = Vector2()
var squaredHalfSizeLength = 0
var currentPointerIDX = INACTIVE_IDX;
var parent


func _ready():
	if !OS.has_touchscreen_ui_hint():
		queue_free()
	else:
		set_process_input(true)
		parent = get_parent()
		halfSize = bg.texture.get_size()/2
		squaredHalfSizeLength = halfSize.x * halfSize.y

#		isDynamicallyShowing = isDynamicallyShowing and parent extends Control
		if isDynamicallyShowing:
			modulate.a = 0
			hide()
		# Unset all events
		dispach_action("ui_jump", false)
	
func _input(event):
	
	var incomingPointer = extractPointerIdx(event)
#	print(incomingPointer)
	
	if incomingPointer == INACTIVE_IDX:
		return
	
	if need2ChangeActivePointer(event):
		if (currentPointerIDX != incomingPointer) and event.is_pressed():
			currentPointerIDX = incomingPointer;
			showAtPos(Vector2(event.position.x, event.position.y));
			dispach_action("ui_jump", true)

	var theSamePointer = currentPointerIDX == incomingPointer
	if isActive() and theSamePointer:
		process_input(event)
		
func need2ChangeActivePointer(event): #touch down inside analog	
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if isDynamicallyShowing:
			#print(get_parent().get_global_rect())
			return get_parent().get_global_rect().has_point(Vector2(event.position.x, event.position.y))
		else:
			var length = (global_position - Vector2(event.position.x, event.position.y)).length_squared();
			return length < squaredHalfSizeLength
	else:
		return false

func isActive():
	return currentPointerIDX != INACTIVE_IDX

func extractPointerIdx(event):
	var touch = event is InputEventScreenTouch
	var drag = event is InputEventScreenDrag
	var gesture = event is InputEventGesture || event is InputEventPanGesture
	var mouseButton = event is InputEventMouseButton
	var mouseMove = event is InputEventMouseMotion
	
	#Ignore event if is outside of its rect
	var parent_rect:Rect2 = parent.get_rect()
	if (touch or drag or gesture) && !parent_rect.has_point(event.position):
		return INACTIVE_IDX
	
	#print(event)
	if touch or drag or gesture:
		return 1
	elif mouseButton or mouseMove:
		#plog("SOMETHING IS VERYWRONG??, I HAVE MOUSE ON TOUCH DEVICE")
		return 0
	else:
#		print(event.as_text())
		return INACTIVE_IDX
		
func process_input(event):
	var isReleased = isReleased(event)
	if isReleased:
		reset()


func reset():
	currentPointerIDX = INACTIVE_IDX
	dispach_action("ui_jump", false)

	if isDynamicallyShowing:
		hide()
	else:
		pass

func showAtPos(pos):
	if isDynamicallyShowing:
		animation_player.play("alpha_in", 0.2)
		position = pos
	
func hide():
	animation_player.play("alpha_out", 0.2) 


func isPressed(event):
	if event is InputEventMouseMotion:
		return (InputEventMouse.button_mask == 1)
	elif event is InputEventScreenTouch:
		return event.is_pressed()

func isReleased(event):
	if event is InputEventScreenTouch:
		return !event.is_pressed()
	elif event is InputEventMouseButton:
		return !event.is_pressed()
	
	
func dispach_action(action:String, pressed: bool):
	var ev = InputEventAction.new()
	ev.action = action
	ev.pressed = pressed
	#ev.strength = 1.0
	Input.parse_input_event(ev)
