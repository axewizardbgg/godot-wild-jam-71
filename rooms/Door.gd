extends Node2D

signal doorClicked(whereTo)


# Required to be set before _ready() is called
var sprPathOpen: String = ""
var sprPathClosed: String = ""
# Optional variables
var open: bool = false
var side: bool = false
var flipped: bool = false
# Determine where the door goes to
var whereTo: String # Expected to be set when created
# What item is needed to interact with this door?
var usableItems: Array = [] # Expected to be set when created
var preferredItem: String = "" # Expected to be set when created
var wrongItemEventName: String = "" # Expected to be set when created
# What is display when we are moused over
var desc: String # Expected to be set when created

# We need to store references to some child nodes we create on the fly
var spr: Sprite
var area2D: Area2D
var colShape: CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setSprite()

func setSprite() -> void:
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
	if open:
		spr.texture = load(sprPathOpen)
	else:
		spr.texture = load(sprPathClosed)
	if flipped:
		scale.x = -1
	# Set the bounds of the collission shape
	var sprSize: Vector2 = spr.texture.get_size()
	colShape.shape.extents = sprSize / 2

func toggleDoor() -> void:
	open = !open
	setSprite()

func handleClick(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.is_pressed():
		# We've been clicked on! Are we already opened?
		if open:
			# We've been opened already, emit signal that we've been clicked
			emit_signal("doorClicked", whereTo)
			return
		# We're not open yet, let's display the menu for the player to select what item the want to use
		# Bring up the menu to determine which item the player wants to use on us
		var menu: Control = load("res://ui/ItemSelection.tscn").instance()
		# Add it to the scene
		get_tree().root.get_node("Main/UICanvasLayer").add_child(menu)
		# Connect signal for when an item is selected
		menu.connect("itemSelected", self, "_itemClicked")

func _on_Area2D_mouse_entered() -> void:
	# Mouse entered, put an outline around our sprite
	spr.material = ShaderMaterial.new()
	spr.material.shader = load("res://shaders/Outline.tres")
	# Set desc label
	Events.updateHoverLabel(desc, false, get_tree())


func _on_Area2D_mouse_exited() -> void:
	# Mouse exited, clear the shader
	spr.material = null
	# Clear desc label if we were moused over last
	Events.updateHoverLabel(desc, true, get_tree())


func _on_Area2D_input_event(_viewport, event: InputEvent, _shape_idx) -> void:
	handleClick(event)

	
func _itemClicked(item: String) -> void:
	# We're not yet open, do we have a usable item?
	if usableItems.has(item) || usableItems.size() == 0:
		# We do! Open the door!
		toggleDoor()
		# Play sound!
		AudioManager.playSound("res://sounds/dooropen.ogg")
		# Was this our preferred item?
		if item == preferredItem:
			# Yes, proceed as normal
			Events.addEntryToChatLog("I opened the door!", "event")
			# We need to update our GameState so if we come back to this room it isn't reset.
			for i in GameState.current.rooms[GameState.current.currentRoom].doors.size():
				# We can compare our whereTo variable to make sure it's us
				if GameState.current.rooms[GameState.current.currentRoom].doors[i].whereTo == whereTo:
					# We have a match, make sure we're open
					GameState.current.rooms[GameState.current.currentRoom].doors[i].open = open
			return
		else:
			# Nope, game over!
			Events.busted(get_tree())
			return
	# If we haven't return yet, we're not able to do anything with this
	var fm: String = Events.randomInteractableFailMessage()
	Events.addEntryToChatLog(fm, "")
