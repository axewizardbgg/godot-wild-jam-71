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
	interactable.sprPath = "res://sprites/GWJ71nuke_lit.png"
	interactable.desc = "WHY YOU LOOKING AT THIS? JUST RUN!"
	# Add it as child
	add_child(interactable)
	# Connect signals
	interactable.connect("interactableClicked", self, "_clicked")
	# We need to it to make a sound while it's down here
	var sndPlayer: AudioStreamPlayer = AudioStreamPlayer.new()
	sndPlayer.stream = load("res://sounds/litfuse.ogg")
	add_child(sndPlayer)
	sndPlayer.play()
	# This is a special case where we need blow up if the player doesn't
	# get out of this room in time, so we prepare a Timer
	var timer: Timer = Timer.new()
	timer.wait_time = 10 # 10 seconds
	# Add the timer to the scene
	add_child(timer)
	# Start the timer
	timer.start()
	# Connect the signal
	timer.connect("timeout", self, "_fail")
	

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
		"Hammer":
			_fail()
		_:
			# Get random fail message
			var fm: String = Events.randomInteractableFailMessage()
			Events.addEntryToChatLog(fm, "")

func _fail() -> void:
	# Game over!
	Events.exploded(get_tree())
