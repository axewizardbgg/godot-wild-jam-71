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
	interactable.sprPath = "res://sprites/GWJ71barrel.png"
	interactable.desc = "A heavy Barrel that sounds like it's full of something."
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
		"Crowbar":
			_open()
		_:
			# Get random fail message
			var fm: String = Events.randomInteractableFailMessage()
			Events.addEntryToChatLog(fm, "")

func _open() -> void:
	# We've interacted with it, let's create a sprite of an open barrel
	var spr: Sprite = Sprite.new()
	spr.texture = load("res://sprites/GWJ71barrelopen.png")
	# Add it as a child and then delete the interactable
	add_child(spr)
	interactable.queue_free()
	# Play sound
	AudioManager.playSound("res://sounds/pryingloose.ogg")
	# We need to update our GameState so if we come back to this room it isn't reset.
	for i in GameState.current.rooms[GameState.current.currentRoom].interactables.size():
		# We can compare our whereTo variable to make sure it's us
		if GameState.current.rooms[GameState.current.currentRoom].interactables[i].globalPos == global_position:
			# We have a match, make sure we're open
			GameState.current.rooms[GameState.current.currentRoom].interactables.remove(i)
			break
	GameState.current.rooms[GameState.current.currentRoom].decor.append({
		"sprPath": "res://sprites/GWJ71barrelopen.png",
		"globalPos": global_position,
		"flipped": false
	})
	# Add entry to the chat log
	if GameState.current.inventory.has("Lit Torch"):
		Events.addEntryToChatLog("Oh no! I spilled water on my Torch...", "fail")
		# We've interacted with it, light our Torch!
		GameState.current.inventory.append("Unlit Torch")
		# Remove the unlit torch from inventory
		GameState.current.inventory.erase("Lit Torch")
		# Did we get an item that affects our cursor? Update cursors just to be safe
		get_tree().root.get_node("Main").updateCursors()
		# Play sound
		AudioManager.playSound("res://sounds/torchlit.ogg")
	else:
		Events.addEntryToChatLog("Hmm, just a Barrel full of water... and it smells bad, gross!", "event")
	
