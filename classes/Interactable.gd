extends Node2D

class_name Interactable

# Define some custom signals that we'll use for when we get clicked
signal interactableClicked

# Should be set before _ready() is called
export var sprPath: String = ""
# What is displayed when we are moused over
export var desc: String = "" # Expected to be set when created

# This can be set when something is added to it.
var addedItems: Array = []

# We need to store references to some child nodes we create on the fly
var spr: Sprite
var area2D: Area2D
var colShape: CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Create our Sprite, Area2D, and CollisionShape2D nodes
	spr = Sprite.new()
	area2D = Area2D.new()
	colShape = CollisionShape2D.new()
	# Define the actual shape of the colShape
	colShape.shape = RectangleShape2D.new()
	# Add them all to scene in the correct order
	area2D.add_child(colShape)
	spr.add_child(area2D)
	add_child(spr) # This should be when it is actually added to the scene tree
	# Connect signals
	area2D.connect("mouse_entered", self, "_on_Area2D_mouse_entered")
	area2D.connect("mouse_exited", self, "_on_Area2D_mouse_exited")
	area2D.connect("input_event", self, "_on_Area2D_input_event")
	# Set the sprite
	spr.texture = load(sprPath)
#	# Do we need to scale the sprite?
#	match sprPath:
#		"res://sprites/GWJ71Rat.png":
#			continue
#		"res://sprites/GWJ71PossumBoots.png":
#			continue
#		"res://sprites/GWJ71skelyBoi.png":
#			continue
#		"res://sprites/GWJ71Slime.png":
#			continue
#		"res://sprites/GWJ71flamango.png":
#			continue
#		"res://sprites/GWJ71McReginald.png":
#			spr.scale = Vector2(2,2)
	# Set the bounds of the collission shape
	var sprSize: Vector2 = spr.texture.get_size()
	colShape.shape.extents = sprSize / 2


func _on_Area2D_mouse_entered():
	# Put an outline around the item
	spr.material = ShaderMaterial.new()
	spr.material.shader = load("res://shaders/Outline.tres")
	# Set desc label
	Events.updateHoverLabel(desc, false, get_tree())


func _on_Area2D_mouse_exited():
	# Remove outline
	spr.material = null
	# Clear desc label if we were moused over last
	Events.updateHoverLabel(desc, true, get_tree())


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.is_pressed():
		# We've been clicked on! 
		emit_signal("interactableClicked")

