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
	interactable.sprPath = "res://sprites/GWJ71nuke_fused.png"
	interactable.desc = "Fuse is set, just need some fire, bruh. Hit it with the flames."
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
		"Lit Torch":
			_open()
		"Hammer":
			_fail()
		_:
			# Get random fail message
			var fm: String = Events.randomInteractableFailMessage()
			Events.addEntryToChatLog(fm, "")

func _open() -> void:
	# Next, create the item on the ground nearby
	var key: Node2D = load("res://interactables/Nuke4.tscn").instance()
	# Add it to the main scene
	get_tree().root.get_node("Main/Room").add_child(key)
	# Reposition the key to be nearby
	key.global_position = global_position
	# Play sound
	AudioManager.playSound("res://sounds/torchlit.ogg")
	# Add entry to the chat log
	Events.addEntryToChatLog("IT'S LIT, IT'S GO TIME BABY! RUN! BOUNCE! SKIDADDLE!", "event")
	# We need to update our GameState so if we come back to this room it isn't reset.
	for i in GameState.current.rooms[GameState.current.currentRoom].interactables.size():
		# We can compare our whereTo variable to make sure it's us
		if GameState.current.rooms[GameState.current.currentRoom].interactables[i].globalPos == global_position:
			# We have a match, make sure we're open
			GameState.current.rooms[GameState.current.currentRoom].interactables.remove(i)
			break
	GameState.current.rooms[GameState.current.currentRoom].interactables.append({
		"scenePath": "res://interactables/Nuke4.tscn",
		"globalPos": global_position,
	})
	queue_free()

func _fail() -> void:
	# Game over!
	Events.exploded(get_tree())