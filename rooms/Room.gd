extends Node2D


# Expected to be set by the calling instance before _ready()
var sprPath: String
var flipped : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set the sprite
	$Sprite.texture = load(sprPath)
	if flipped:
		$Sprite.flip_h = true
	

