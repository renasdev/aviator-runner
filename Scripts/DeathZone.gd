extends Area2D

func _on_DeathZone_body_entered(body):
	if(GameGlobals.is_player(body)):
		body.instant_kill()
