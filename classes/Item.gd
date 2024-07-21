extends Node2D

class_name Item

signal addedToInventory


# Should be set before _ready() is called
export var sprPath: String
# If the player picks us up, this is what is in the inventory
export var itemName: String
# What is display when we are moused over
export var desc: String # Expected to be set when created

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
	# Set the bounds of the collission shape
	var sprSize: Vector2 = spr.texture.get_size()
	colShape.shape.extents = sprSize / 2


func _on_Area2D_mouse_entered() -> void:
	# Put an outline around the item
	spr.material = ShaderMaterial.new()
	spr.material.shader = load("res://shaders/Outline.tres")
	# Set the desc label to be our description
	Events.updateHoverLabel(desc, false, get_tree())


func _on_Area2D_mouse_exited() -> void:
	# Remove outline
	spr.material = null
	# Clear desc label
	Events.updateHoverLabel(desc, true, get_tree())


func _on_Area2D_input_event(_viewport, event: InputEvent, _shape_idx) -> void:
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.is_pressed():
		# We've been clicked on! Add ourselves to the inventory
		GameState.current.inventory.append(itemName)
		# We need to update our GameState so if we come back to this room it isn't reset.
		for i in GameState.current.rooms[GameState.current.currentRoom].items.size():
			# We can compare our whereTo variable to make sure it's us
			if GameState.current.rooms[GameState.current.currentRoom].items[i].globalPos == global_position:
				# We have a match, make sure we're open
				GameState.current.rooms[GameState.current.currentRoom].items.remove(i)
				break
		# We didn't trigger an event did we?
		if sprPath == "res://sprites/GWJ71pileofgold.png":
			# WE GOT ROBBED!
			Events.robbed(get_tree())
			return
		# Did we get an item that affects our cursor? Update cursors just to be safe
		get_tree().root.get_node("Main").updateCursors()
		# We need to remove ourselves from the room state so we're not re-added
		var currRoom: String = GameState.current.currentRoom
		GameState.current.rooms[currRoom].items.erase(itemName)
		# Play sound
		AudioManager.playSound("res://sounds/pop.ogg")
		# Add an entry to the chatlog that we picked up a new item
		var msg: String = itemName + " added to inventory!"
		Events.addEntryToChatLog(msg, "event")
		# Emit signal that we've added an item to the inventory
		emit_signal("addedToInventory")
		# Clear desc label if we were moused over last
		Events.updateHoverLabel(desc, true, get_tree())
		# Now we can destroy ourselves!
		queue_free()
