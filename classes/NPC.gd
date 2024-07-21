extends Node2D


# Should be set before _ready() is called
export var sprPath: String
# What is display when we are moused over
export var desc: String # Expected to be set when created


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set the sprite
	$Sprite.texture = load(sprPath)
	# Resize the collision shape
	var sprSize: Vector2 = $Sprite.texture.get_size()
	var rad: float = (sprSize.x / 2) - 4
	$CollisionShape2D.shape.radius = rad


func _on_Area2D_mouse_entered() -> void:
	# Put an outline around the item
	print("Item moused over!")
	$Sprite.material = ShaderMaterial.new()
	$Sprite.material.shader = load("res://shaders/Outline.tres")


func _on_Area2D_mouse_exited() -> void:
	# Remove outline
	print("Item no longer moused over...")
	$Sprite.material = null


func _on_Area2D_input_event(_viewport, event: InputEvent, _shape_idx) -> void:
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.is_pressed():
		# We've been clicked on! 
		print("Interactable clicked!")
		# TODO: Figure out how to call events
