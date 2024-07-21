extends Node2D


# Declare member variables here. Examples:
var scrollSpeed: float = 10 # Pixels per second
var currPos: float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.playSound("res://sounds/bahyougotit.ogg")
	# Create our cursor
	var cursorScene: PackedScene = preload("res://MouseCursor.tscn")
	var cursor: Node2D = cursorScene.instance()
	# Add it to the tree
	add_child(cursor)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	currPos -= (scrollSpeed * delta)
	$Move.global_position.y = currPos
	if $Move.global_position.y <= -850:
		# Close the game!
		get_tree().quit()


func _on_Button_pressed():
	# Close the game!
	get_tree().quit()
