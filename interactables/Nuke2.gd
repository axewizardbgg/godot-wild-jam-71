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
	interactable.sprPath = "res://sprites/GWJ71nuke_exposed.png"
	interactable.desc = "Ok I can see all the splodey bits inside... be careful!"
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
		"Rope":
			_open()
		"Hammer", "Lit Torch", "Lighter":
			_fail()
		_:
			# Get random fail message
			var fm: String = Events.randomInteractableFailMessage()
			Events.addEntryToChatLog(fm, "")

func _open() -> void:
	# Next, create the item on the ground nearby
	var key: Node2D = load("res://interactables/Nuke3.tscn").instance()
	# Add it to the main scene
	get_tree().root.get_node("Main/Room").add_child(key)
	# Reposition the key to be nearby
	key.global_position = global_position
	# Play sound
	AudioManager.playSound("res://sounds/pickup.ogg")
	# Add entry to the chat log
	Events.addEntryToChatLog("Made a makeshift fuse... guess I just have to light it now?", "event")
	# We need to update our GameState so if we come back to this room it isn't reset.
	for i in GameState.current.rooms[GameState.current.currentRoom].interactables.size():
		# We can compare our whereTo variable to make sure it's us
		if GameState.current.rooms[GameState.current.currentRoom].interactables[i].globalPos == global_position:
			# We have a match, make sure we're open
			GameState.current.rooms[GameState.current.currentRoom].interactables.remove(i)
			break
	GameState.current.rooms[GameState.current.currentRoom].interactables.append({
		"scenePath": "res://interactables/Nuke3.tscn",
		"globalPos": global_position,
	})
	queue_free()

func _fail() -> void:
	# Game over!
	Events.exploded(get_tree())
