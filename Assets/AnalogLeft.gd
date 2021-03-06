extends Node2D

const INACTIVE_IDX = -1;
export var isDynamicallyShowing = false
export var listenerNodePath = "/root/game/player"
export var isSingleHand = false

var ball
var bg 
var animation_player
var parent

var centerPoint = Vector2(0,0)
var currentForce = Vector2(0,0)
var halfSize = Vector2()
var ballPos = Vector2()
var squaredHalfSizeLength = 0
var currentPointerIDX = INACTIVE_IDX;

func _ready():
	if !OS.has_touchscreen_ui_hint():
		queue_free()
	else:
		set_process_input(true)
		bg = get_node("bg")
		ball = get_node("ball")	
		animation_player = get_node("AnimationPlayer")
		parent = get_parent()
		halfSize = bg.texture.get_size()/2
		squaredHalfSizeLength = halfSize.x * halfSize.y
		
		if (listenerNodePath != "" && listenerNodePath!=null):
			listenerNodePath = get_node(listenerNodePath)
		elif listenerNodePath=="":
			listenerNodePath = null
	
	#	isDynamicallyShowing = isDynamicallyShowing and parent extends Control
		if isDynamicallyShowing:
			modulate.a = 0
	#		hide()
		# Unset all events
		dispach_action("ui_right", false)
		dispach_action("ui_left", false)
		dispach_action("ui_down", false)
		
		if isSingleHand:
			dispach_action("ui_up", false)
			dispach_action("ui_jump", false)
		

func get_force():
	return currentForce
	
func _input(event):
	
	var incomingPointer = extractPointerIdx(event)
	#print(incomingPointer)
	
	if incomingPointer == INACTIVE_IDX:
		return
	
	if need2ChangeActivePointer(event):
		if (currentPointerIDX != incomingPointer) and event.is_pressed():
			currentPointerIDX = incomingPointer;
			showAtPos(Vector2(event.position.x, event.position.y));

	var theSamePointer = currentPointerIDX == incomingPointer
	if isActive() and theSamePointer:
		process_input(event)

func need2ChangeActivePointer(event): #touch down inside analog	
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if isDynamicallyShowing:
			return isSingleHand || get_parent().get_global_rect().has_point(Vector2(event.position.x, event.position.y))
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
	if touch or drag:
		return 1
	elif mouseButton or mouseMove:
		#plog("SOMETHING IS VERYWRONG??, I HAVE MOUSE ON TOUCH DEVICE")
		return 0
	else:
		return INACTIVE_IDX
		
func process_input(event):
	calculateForce(event.position.x - global_position.x, event.position.y - global_position.y)
	updateBallPos()
	
	var isReleased = isReleased(event)
	if isReleased:
		reset()


func reset():
	currentPointerIDX = INACTIVE_IDX
	calculateForce(0, 0)

	if isDynamicallyShowing:
		hide()
	else:
		updateBallPos()

func showAtPos(pos):	
	if isDynamicallyShowing:
		animation_player.play("alpha_in", 0.0)
		global_position = pos
	
func hide():
	animation_player.play("alpha_out", 0.0) 

func updateBallPos():
	ballPos.x = halfSize.x * currentForce.x #+ halfSize.x
	ballPos.y = halfSize.y * -currentForce.y #+ halfSize.y
	ball.position = Vector2(ballPos.x, ballPos.y)

func calculateForce(var x, var y):
	#get direction
	currentForce.x = (x - centerPoint.x)/halfSize.x
	currentForce.y = -(y - centerPoint.y)/halfSize.y
	#print(currentForce.x, currentForce.y)
	#limit 
	#print(currentForce.length_squared())
	if currentForce.length_squared()>1:
		currentForce=currentForce/currentForce.length()
	
	sendSignal2Listener()

func sendSignal2Listener():
	if(currentForce.x < 0):
		dispach_action("ui_left", true)
		dispach_action("ui_right", false)
	elif(currentForce.x > 0):
		dispach_action("ui_right", true)
		dispach_action("ui_left", false)
	else:
		dispach_action("ui_right", false)
		dispach_action("ui_left", false)
		
	if isSingleHand:
		dispach_action("ui_up", currentForce.y >= 0.3)
		dispach_action("ui_jump", currentForce.y >= 0.3)
	dispach_action("ui_down", currentForce.y <= -0.3)
		
	#print(currentForce)
		
		
func dispach_action(action:String, pressed: bool):
	var ev = InputEventAction.new()
	ev.action = action
	ev.pressed = pressed
	#ev.strength = 1.0
	Input.parse_input_event(ev)

func releaseInputs():
	var inputs = ["ui_left", "ui_right", "ui_jump"]
	
	for ip in inputs:
		print("Releasing " + ip)
		var ev = InputEventAction.new()
		ev.action = ip
		ev.pressed = false
		Input.parse_input_event(ev)

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
