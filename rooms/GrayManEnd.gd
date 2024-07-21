extends Sprite



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Rotate the sprite
	var rotSpd: float = deg2rad(360)
	global_rotation += (rotSpd * delta)
