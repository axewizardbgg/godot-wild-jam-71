extends Node2D


# When a player clicks on us, we display a menu, let's just preload it
var menuScene: PackedScene = preload("res://ui/ItemSelection.tscn")
# We'll need to keep track of some references
var interactable: Interactable
# We only want to play their sound once
var sndPlayed: bool = false
var line: int = 0

# Dialogue lines
var lines: Array = [
	"Another victim for the Ogre I see... Welcome!",
	"So you wish to escape? I too had such notions...",
	"Very well, your determination has moved me! Listen closely...",
	"First, you need to make sure you're at least somewhat quiet.",
	"He's used to the others' noises, but loudness attracts attention.",
	"You need to get through the Gate, however it's currently broken.",
	"The door to the left of Gate is where the levers are.",
	"If you can get there, talk to SlimeBoi, he'll guide you further...",
	"But to do that, you need to distract the Ogre.",
	"*looks at nuke* I'm sure you can figure something out!",
	"Good luck!"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Create our Interactable stuff
	interactable = load("res://classes/Interactable.tscn").instance()
	# Set it's variables
	interactable.sprPath = "res://sprites/GWJ71skelyBoi.png"
	interactable.desc = "... A Skeleton is just legit chillin' this basement?"
	# Add it as child
	add_child(interactable)
	interactable.scale = Vector2(2,2)
	# Connect signals
	interactable.connect("interactableClicked", self, "_clicked")

# Signal connector functions
func _clicked() -> void:
	# Do we need to play our sound?
	if !sndPlayed:
		AudioManager.playSound("res://sounds/skeleboiclick.ogg")
		sndPlayed = true
	# We put a line in the chatlog
	Events.addEntryToChatLog("SkeleBoi: "+lines[line], "dialogue")
	# Increment the line
	line += 1
	# Was that our last line?
	if line > lines.size()-1:
		# It was, just have him keep repeating his last line.
		line -= 1
	

