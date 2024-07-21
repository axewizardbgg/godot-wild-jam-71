extends Node2D


# We need to keep a reference to our cursor object so we can update the sprite when needed
var cursor: Node2D # Will be set in _ready()
var cursorUI: Node2D # Will be set in _ready()
onready var descLabel: Control = $UICanvasLayer/DescLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Populate the room
	prepareRoom()
	# Let's make it dark now so we can make use of our torch
	var darkness: CanvasModulate = CanvasModulate.new()
	darkness.color = Color(0.2,0.2,0.2)
	# Add it to the scene
	add_child(darkness)
	# Create our cursor
	var cursorScene: PackedScene = preload("res://MouseCursor.tscn")
	cursor = cursorScene.instance()
	# Add it to the tree
	add_child(cursor)
	# Add our chatlog to the UI canvas
	var chatLog: Control = load("res://ui/ChatLog.tscn").instance()
	$UICanvasLayer.add_child(chatLog)
	# Prepare our UI only cursor (so the cursor doesn't appear behind the buttons)
	cursorUI = cursorScene.instance()
	cursorUI.uiOnly = true
	$UICanvasLayer.add_child(cursorUI)
	

func clearScene() -> void:
	# TODO: This might need to be made less brittle later
	# Delete only the Room
	var rm: Node2D = get_node_or_null("Room")
	if is_instance_valid(rm):
		rm.name = "RoomDeleted" 
		rm.queue_free()

# Creates and populates the scene, determined by current state of GameState
func prepareRoom() -> void:
	get_tree().paused = false
	# Clear the scene first
	clearScene()
	# Let's make the room
	var room: Node2D = preload("res://rooms/Room.tscn").instance()
	room.pause_mode = Node.PAUSE_MODE_STOP
	var currRoom: String = GameState.current.currentRoom
	room.sprPath = GameState.current.rooms[currRoom].sprPath
	room.flipped = GameState.current.rooms[currRoom].flipped
	add_child(room)
	room.name = "Room"
	# Room is set up, let's populate it with all of its things
	# Let's start with non-interactable decor
	var decor: Array = GameState.current.rooms[currRoom].decor
	for decoration in decor:
		# These are just sprites, so make a new sprite and set the texture
		var spr: Sprite = Sprite.new()
		spr.texture = load(decoration.sprPath)
		if decoration.flipped:
			spr.flip_h = true
		# Is this a lightsource?
		if decoration.sprPath == "res://sprites/GWJ71Lantern.png":
			# Yup! Let's add a light to it for funsies
			var l: Node2D = load("res://rooms/Light.tscn").instance()
			l.lightScale = 1
			spr.add_child(l)
		# Add it to the scene and then set the position
		room.add_child(spr)
		spr.global_position = decoration.globalPos
	# Now we'll do Doors
	var doors: Array = GameState.current.rooms[currRoom].doors
	for d in doors:
		# We have a door, create the door
		var door: Node2D = preload("res://rooms/Door.tscn").instance()
		# This is a terrible way of doing this but whatever, YOLO
		door.open = d.open
		door.whereTo = d.whereTo
		door.usableItems = d.usableItems
		door.preferredItem = d.preferredItem
		door.wrongItemEventName = d.wrongItemEventName
		door.flipped = d.flipped
		door.desc = d.desc
		door.sprPathOpen = d.sprPathOpen
		door.sprPathClosed = d.sprPathClosed
		# Does this door need a lightsource?
		if d.sprPathOpen == "res://sprites/GWJ71_LadderUp.png":
			# Yup! Let's add a light to it for funsies
			var l: Node2D = load("res://rooms/Light.tscn").instance()
			l.lightScale = 1
			l.offset = 0
			l.energy = 0.5
			door.add_child(l)
			l.position = Vector2(0,-58)
		# Add the door to our room scene
		room.add_child(door)
		# Position our door
		door.global_position = d.globalPos
		# Connect door signal
		door.connect("doorClicked", self, "handleDoorClicked")
	# We've added any doors, now let's add any Items
	var items: Array = GameState.current.rooms[currRoom].items
	for i in items:
		# We have an item, create the item
		var item: Node2D = load(i.scenePath).instance()
		# Add it to the room
		room.add_child(item)
		# Position our item
		item.global_position = i.globalPos
	# Interactables next, even though we could realistically put them with Items in the current
	# workflow, but I prefer to keep them separate in case that changes in the future.
	var interactables: Array = GameState.current.rooms[currRoom].interactables
	for i in interactables:
		# We have an item, create the item
		var interactable: Node2D = load(i.scenePath).instance()
		# Add it to the room
		room.add_child(interactable)
		# Position our item
		interactable.global_position = i.globalPos
	# Finally, we check for some special progress
	if GameState.current.currentRoom == "room4":
		# We're in room 4, do we have a lit nuke?!
		for i in GameState.current.rooms[GameState.current.currentRoom].interactables.size():
			# We can compare the scenePath variable to make sure it's the right nuke
			if GameState.current.rooms[GameState.current.currentRoom].interactables[i].scenePath == "res://interactables/Nuke4.tscn":
				# We have a match, player made the wrong choice. Explode!
				Events.exploded(get_tree())
				break
	# Are we in the first room?
	var litNuke: bool = false # Doing this to avoid further nesting
	if GameState.current.currentRoom == "room1":
		# We are, do we have a lit nuke in room 4?
		for i in GameState.current.rooms["room4"].interactables.size():
			# We can compare the scenePath variable to make sure it's the right nuke
			if GameState.current.rooms["room4"].interactables[i].scenePath == "res://interactables/Nuke4.tscn":
				# Yes the nuke is lit
				litNuke = true
				break
	if litNuke:
		# We have a match, player made the right choice, make explosion sound effect
		AudioManager.playSound("res://sounds/b-b-boom.ogg")
		# Write a message
		Events.addEntryToChatLog("This is my chance! The Ogre should be distracted!", "event")
		# Open the other door in room2
		for d in GameState.current.rooms["room2"].doors.size():
			# We'll determine the right door by global pos
			if GameState.current.rooms["room2"].doors[d].globalPos == Vector2(35,125):
				# We have a match, update it to be open
				GameState.current.rooms["room2"].doors[d].open = true
				break
		# Mark that the nuke has exploded
		GameState.current.nukeExploded = true
	# If the nuke has exploded, the Shrenk should bust the player if they go back into room3
	if GameState.current.nukeExploded == true && GameState.current.currentRoom == "room3":
		# Game over screen!
		Events.busted(get_tree())
	# Are we in the final room?
	if GameState.current.currentRoom == "room6":
		# Victory!
		Events.victory(get_tree())
	

func handleDoorClicked(whereTo: String) -> void:
	# Set the current room
	GameState.current.currentRoom = whereTo
	# Prepare the room!
	prepareRoom()

func updateCursors():
	cursor.updateSprite()
	cursorUI.updateSprite()
	
func credits() -> void:
	pass # TODO
