extends Control


# These variables are expected to be set before _ready() is called.
var interactable: Node2D

# Custom signal for when an item is selected
signal itemSelected(item)

# Track references to nodes we'll need to manage
onready var itemArea: VBoxContainer = $CC/VBC/SC/VBC

# We needed to make our own MenuButton so we can make a custom signal
var buttonScene: PackedScene = preload("res://ui/ItemEntry.tscn")

# Called when node enters the scene tree for the first time
func _ready() -> void:
	# Create a menu button for the player to cancel
	var cb: MenuButton = MenuButton.new()
	cb.text = "None (Cancel)"
	cb.flat = false
	cb.toggle_mode = false
	# Add to the scene
	itemArea.add_child(cb)
	# Connect signal
	cb.connect("pressed", self, "_cancel")
	# We need to create menu buttons for each item the player has
	for item in GameState.current.inventory:
		# Prepare Menubutton
		var mb: MenuButton = buttonScene.instance()
		mb.text = item
		mb.flat = false
		mb.toggle_mode = false
		# Add to the scene
		itemArea.add_child(mb)
		# Connect signal
		mb.connect("itemEntryPressed", self, "_menuButtonClicked")

# Signal connector function for when a menu button is clicked
func _menuButtonClicked(item: String) -> void:
	# Emit signal that an item was selected
	emit_signal("itemSelected", item)
	# Destroy ourself
	queue_free()

# Signal connector function to cancel
func _cancel() -> void:
	queue_free()
