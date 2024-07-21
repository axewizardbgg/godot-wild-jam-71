extends Node2D


# When a player clicks on us, we display a menu, let's just preload it
var menuScene: PackedScene = preload("res://ui/ItemSelection.tscn")
# We'll need to keep track of some references
var interactable: Interactable
# We only want to play their sound once
var sndPlayed: bool = false
var line: int = 0
var hammerGiven: bool = false

# Dialogue lines
var lines: Array = [
	"Who are you? No matter, I need your help!",
	"The Gate is broken, and that stupid Ogre is no help.",
	"I'm trying to repair the damaged cog, but I need a Hammer!",
	"Do you have one? GIMME!"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Create our Interactable stuff
	interactable = load("res://classes/Interactable.tscn").instance()
	# Set it's variables
	interactable.sprPath = "res://sprites/GWJ71Slime.png"
	interactable.desc = "Yo this Slime is armored... probly packin' heat too!"
	# Add it as child
	add_child(interactable)
	interactable.scale = Vector2(2,2)
	# Connect signals
	interactable.connect("interactableClicked", self, "_clicked")

# Signal connector functions
func _clicked() -> void:
	# Do we need to play our sound?
	if !sndPlayed:
		AudioManager.playSound("res://sounds/slimeclick.ogg")
		sndPlayed = true
	# Have we already done a bunch with this guy already?
	if hammerGiven:
		# Yes, just play a dialogue line and skip the rest
		Events.addEntryToChatLog("SlimeBoi: I gave you the Cog, now MAKE IT WORK!", "dialogue")
		return
	# We put a line in the chatlog
	Events.addEntryToChatLog("SlimeBoi: "+lines[line], "dialogue")
	# Increment the line
	line += 1
	# Was that our last line?
	if line > lines.size()-1:
		# It was, just have him keep repeating his last line.
		line -= 1
		# We'll also bring up the item menu
		var menu: Control = menuScene.instance()
		# Add it to the scene
		get_tree().root.get_node("Main/UICanvasLayer").add_child(menu)
		# Connect signal for when an item is selected
		menu.connect("itemSelected", self, "_itemClicked")

func _itemClicked(item: String) -> void:
	match item:
		"Hammer":
			_open()
		_:
			# Get random fail message
			var fm: String = Events.randomInteractableFailMessage()
			Events.addEntryToChatLog("SlimeBoi: That's not a Hammer you fool!", "dialogue")

func _open() -> void:
	hammerGiven = true
	# Next, create the item on the ground nearby
	var cushion: Item = load("res://items/ItemCog.tscn").instance()
	# Add it to the main scene
	get_tree().root.get_node("Main/Room").add_child(cushion)
	# Reposition the key to be nearby
	cushion.global_position = global_position + Vector2(50,15)
	GameState.current.rooms[GameState.current.currentRoom].items.append({
		"scenePath": "res://items/ItemCog.tscn",
		"globalPos": cushion.global_position,
	})
	# Play sound
	AudioManager.playSound("res://sounds/anvil.ogg")
	# Add entry to the chat log
	Events.addEntryToChatLog("Wow he fixed this cog in one hit... and with no arms! WHOA!", "event")


