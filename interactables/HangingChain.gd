extends Node2D


# When a player clicks on us, we display a menu, let's just preload it
var menuScene: PackedScene = preload("res://ui/ItemSelection.tscn")
# We'll need to keep track of some references
var interactable: Interactable

var cushion: Sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Create our Interactable stuff
	interactable = load("res://classes/Interactable.tscn").instance()
	# Set it's variables
	interactable.sprPath = "res://sprites/GWJ71Chain.png"
	interactable.desc = "A dangling Chain that is fixed to the ceiling."
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
		"Cushion":
			_placeItem()
		_:
			# Get random fail message
			var fm: String = Events.randomInteractableFailMessage()
			Events.addEntryToChatLog(fm, "")

func _open() -> void:
	# Destroy the interactable stuff, we're about to create an item.
	interactable.queue_free()
	# Next, create the item on the ground nearby
	var chain: Item = load("res://items/ItemChain.tscn").instance()
	# Add it to the main scene
	get_tree().root.get_node("Main/Room").add_child(chain)
	# Reposition the coiled up chain to be to beneath where we are
	chain.global_position = Vector2(global_position.x, 110)
	# Add it to GameState in case the player leaves
	GameState.current.rooms[GameState.current.currentRoom].items.append({
		"scenePath": "res://items/ItemChain.tscn",
		"globalPos": chain.global_position,
	})
	# Add entry to the chat log
	Events.addEntryToChatLog("I pried the Chain loose!", "event")
	AudioManager.playSound("res://sounds/chains.ogg")
	# Do we have our cushion in place?
	if !is_instance_valid(cushion):
		# Nope! We got a problem, play sound
		AudioManager.playSound("res://sounds/impact.ogg")
		Events.addEntryToChatLog("Uh oh, that was way too loud! OH LAWD HE COMIN!", "fail")
		Events.busted(get_tree())
		return
	# We do!
	AudioManager.playSound("res://sounds/cushion.ogg")
	# We need to update our GameState so if we come back to this room it isn't reset.
	for i in GameState.current.rooms[GameState.current.currentRoom].interactables.size():
		# We can compare our whereTo variable to make sure it's us
		if GameState.current.rooms[GameState.current.currentRoom].interactables[i].globalPos == global_position:
			# We have a match, make sure we're open
			GameState.current.rooms[GameState.current.currentRoom].interactables.remove(i)
			break
	GameState.current.rooms[GameState.current.currentRoom].decor.append({
		"sprPath": "res://sprites/GWJ71Cushion.png",
		"globalPos": cushion.global_position,
		"flipped": false
	})
	

func _placeItem():
	# In this case we're placing a cushion beneath the chain to dampen the noise
	cushion = Sprite.new()
	cushion.texture = load("res://sprites/GWJ71Cushion.png")
	# Remove the cushion form inventory
	GameState.current.inventory.erase("Cushion")
	# Add it to the main scene
	get_tree().root.get_node("Main/Room").add_child(cushion)
	# Play sound
	AudioManager.playSound("res://sounds/cushion.ogg")
	# Reposition the coiled up chain to be to beneath where we are
	cushion.global_position = Vector2(global_position.x, 110)
	# Add entry to the chat log
	Events.addEntryToChatLog("I placed the soft Cushion underneath to catch the Chain.", "event")
