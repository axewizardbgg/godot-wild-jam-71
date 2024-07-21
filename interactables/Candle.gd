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
	interactable.sprPath = "res://sprites/GWJ71Candle.png"
	interactable.desc = "A flickering Candle emitting a dim light."
	# Add it as child
	add_child(interactable)
	# Connect signals
	interactable.connect("interactableClicked", self, "_clicked")

func _process(_delta: float) -> void:
	$Light2D.position = Vector2(round(rand_range(-2,2)),round(rand_range(-2,2)))

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
		"Unlit Torch":
			_open()
		_:
			# Get random fail message
			var fm: String = Events.randomInteractableFailMessage()
			Events.addEntryToChatLog(fm, "")

func _open() -> void:
	# We've interacted with it, light our Torch!
	GameState.current.inventory.append("Lit Torch")
	# Remove the unlit torch from inventory
	GameState.current.inventory.erase("Unlit Torch")
	# Did we get an item that affects our cursor? Update cursors just to be safe
	get_tree().root.get_node("Main").updateCursors()
	# Play sound
	AudioManager.playSound("res://sounds/torchlit.ogg")
