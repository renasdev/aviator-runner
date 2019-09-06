extends Area2D

func _on_DeathZone_body_entered(body):
	if(body.get_name() == GameConstants.PLAYER):
		# Kill player
		body.instant_kill()
