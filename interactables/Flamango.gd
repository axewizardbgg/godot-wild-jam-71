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
	"Sup noob. The name's FlaMANgo. *flexes*",
	"Have you see my beach ball? It's shaped like THIS. *flexes*",
	"What? You're asking if I skip leg day? GET OUT OF MY FACE.",
	"WHAT do you want? You're getting on my nerves bro.",
	"YOU WANNA THROW DOWN?!",
	"... Meh, you're not worth my time, chump.",
	"Now you've done it! *starts screaming*"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Create our Interactable stuff
	interactable = load("res://classes/Interactable.tscn").instance()
	# Set it's variables
	interactable.sprPath = "res://sprites/GWJ71flamango.png"
	interactable.desc = "What appears to be a Flamingo trying to flex on the haters."
	# Add it as child
	add_child(interactable)
	interactable.scale = Vector2(2,2)
	# Connect signals
	interactable.connect("interactableClicked", self, "_clicked")

# Signal connector functions
func _clicked() -> void:
	# Do we need to play our sound?
	if !sndPlayed:
		AudioManager.playSound("res://sounds/flamangoclick.ogg")
		sndPlayed = true
	# We put a line in the chatlog
	Events.addEntryToChatLog("FlaMANgo: "+lines[line], "dialogue")
	# Increment the line
	line += 1
	# Was that our last line?
	if line > lines.size()-1:
		# It was, game over!
		Events.busted(get_tree())
	

