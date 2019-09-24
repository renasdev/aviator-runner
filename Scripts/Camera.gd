extends Camera2D

var is_shaking := false
var shake_amount := 0.0

onready var skake_timer = Timer.new()

func _ready():
	GameGlobals.set_current_camera(self)
	skake_timer.connect("timeout",self,"_on_shake_timeout")
	add_child(skake_timer)

func shake(amount:float, time:float):
	is_shaking = true
	shake_amount = amount
	skake_timer.set_wait_time( time )
	skake_timer.start()

func _on_shake_timeout():
	is_shaking = false

func _process(_delta):
	if is_shaking:
	    set_offset(Vector2( \
	        rand_range(-1.0, 1.0) * shake_amount, \
	        rand_range(-1.0, 1.0) * shake_amount \
	    ))