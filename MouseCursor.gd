extends Node2D


# Declare member variables here. Examples:
# var sprPath: String # Expected to be set by creator
var torch: bool = false # Changes cursor to unlit torch
var light: bool = false # Changes cursor to lit torch
var uiOnly: bool = false # If this is true it will not emit light

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateSprite()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Move ourselves to be at the mouse position
	global_position = get_viewport().get_mouse_position()
	# Do we need to make our light flicker?
	if light:
		$Light2D.position = Vector2(round(rand_range(-5,5)),round(rand_range(-5,5)))

func updateSprite() -> void:
	# Do we need to have our light enabled?
	if uiOnly:
		# We shouldn't have light on this UI canvas, hide the light
		$Light2D.visible = false
	else:
		$Light2D.visible = true
	# Set our sprite's texture
	var sprPath: String = "res://sprites/GWJ71cursorhandopen.png"
	var sprOffset: Vector2 = Vector2(-3, -3)
	light = false
	$Light2D.energy = 0.5
	$Light2D.texture_scale = 2
	if GameState.current.inventory.has("Unlit Torch"):
		sprPath = "res://sprites/GWJ71UnlitTorch.png"
		sprOffset = Vector2(-1, -1)
		light = false
	if GameState.current.inventory.has("Lit Torch"):
		sprPath = "res://sprites/GWJ71LitTorch.png"
		sprOffset = Vector2(-3, -3)
		light = true
		$Light2D.energy = 1
		$Light2D.texture_scale = 5
	$Sprite.texture = load(sprPath)
	$Sprite.offset = sprOffset
	# Hide the actual mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func hideLight() -> void:
	$Light2D.visible = false
