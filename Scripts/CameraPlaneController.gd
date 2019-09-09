extends Camera2D

export (NodePath) var camera_animation_player_path

onready var trail_animation_player = get_node(camera_animation_player_path)

func _ready():
	trail_animation_player.play("Trail")