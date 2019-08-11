extends Node2D

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass


func _on_Area2D_body_entered(body):
	if(body.get_name() == GameConstants.PLAYER):
		body.increment_gems(1)
		$AudioStreamPlayer2D.play(0.0)
		$Timer.start(0)


func _on_Timer_timeout():
	self.queue_free()
