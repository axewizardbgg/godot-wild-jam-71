extends Node2D


# When a player clicks on us, we display a menu, let's just preload it
var menuScene: PackedScene = preload("res://ui/ItemSelection.tscn")
# We'll need to keep track of some references
var interactable: Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Create our Interactable stuff
	interactable = load("res://classes/Interactable.tscn").instance()
	# Set it's variables
	interactable.sprPath = "res://sprites/GWJ71LeverOff.png"
	interactable.desc = "A lever, but the handle is missing..."
	# Add it as child
	add_child(interactable)
	# Connect signals
	interactable.connect("interactableClicked", self, "_clicked")

# Signal connector functions
func _clicked() -> void:
	# Bring up the menu to determine which item the player wants to use on us
	var menu: Control = menuScene.instance()
	# Add it to the scene
	get_tree().root.get_node("Main/UICanvasLayer").add_child(menu)
	# Connect signal for when an item is selected
	menu.connect("itemSelected", self, "_itemClicked")

func _itemClicked(item: String) -> void:
	match item:
		"Long Pipe":
			_open()
		_:
			# Get random fail message
			var fm: String = Events.randomInteractableFailMessage()
			Events.addEntryToChatLog(fm, "")

func _open() -> void:
	# Add entry to the chat log
	Events.addEntryToChatLog("I used the Long Pipe as a lever handle. I'm a GENIUS!", "event")
	# Play sound
	if GameState.current.leverOn:
		AudioManager.playSound("res://sounds/crankdown.ogg")
		# Are the gears fixed?
		if GameState.current.gearsFixed:
			# Yes, play a sound of the gate closing!
			AudioManager.playSound("res://sounds/gateClose.ogg")
			# Put a message in chat too
			Events.addEntryToChatLog("Why did I close the Gate?! WHY?!", "fail")
			# Game over!
			Events.busted(get_tree())
		GameState.current.leverOn = false
		interactable.sprPath = "res://sprites/GWJ71LeverOff.png"
		return
	else:
		AudioManager.playSound("res://sounds/crankup.ogg")
		GameState.current.leverOn = true
		# Are the gears fixed?
		if GameState.current.gearsFixed:
			# Yes, play a sound of the gate opening!!
			AudioManager.playSound("res://sounds/gateOpen.ogg")
			# Put a message in chat too
			Events.addEntryToChatLog("The Gate is open! THIS IS MY CHANCE! FREEDOM!", "event")
			# Actually open the damn gate!
			# Open the other door in room2
			for d in GameState.current.rooms["room2"].doors.size():
				# We'll determine the right door by global pos
				if GameState.current.rooms["room2"].doors[d].globalPos == Vector2(160,102):
					# We have a match, update it to be open
					GameState.current.rooms["room2"].doors[d].open = true
					break
		GameState.current.leverOn = true
		interactable.sprPath = "res://sprites/GWJ71LeverOn.png"
	

