extends Node


# There will be a lot of fail messages as players try different things. Let's
# keep it interesting by adding a lot of variety in fail messages
var interactableFailMessages: Array = [
	"I don't know how to use that with this...",
	"Bro I have no idea what you're trying to do.",
	"Are you being for real right now?",
	"I don't know how to do that.",
	"Not sure what you are trying to do here.",
	"I got no idea what is happening right now.",
	"How would that work?",
	"It's not working.",
	"Nothing is happening.",
	"It's not doing anything.",
	"I don't think this is what I'm supposed to do with that.",
	"Try something else I guess...",
	"Nope.",
	"Nada.",
	"No.",
	"Not happening.",
	"OMG I think it's doing something! SYKE! It didn't do anything.",
	"What if... we didn't do that?",
	"... Guess that won't work.",
	"Woops, I think I almost broke it.",
	"That's like putting the square peg in the round hole.",
	"Nothing happened.",
	"WHY WON'T YOU JUST WORK?!",
	"I don't think that does what you think it does.",
	"Abandon thine foolish notion.",
	"Some things are just not possible.",
	"I don't think the developer thought of that lol.",
	"I bet Chuck Norris could make that work..."
]

func randomInteractableFailMessage() -> String:
	var i: int = randi() % interactableFailMessages.size()
	return interactableFailMessages[i]

var itemFailMessages: Array = [
	"It won't budge.",
	"I can't seem to pick this thing up.",
	"I probably need something to get this free.",
	"Nope, can't do it homie.",
	"Bruh, people don't think it be like it be but it do.",
	"It's not working.",
	"Nope.",
	"Can't seem to get it.",
	"I think I'm missing something.",
	"It's stuck.",
	"It's firmly fixed in place.",
	"I think I can get it... Nah.",
	"Maybe I should use my teeth or something...",
	"I bet Chuck Norris could pick this up...",
	"Man, that would look so good in my Inventory...",
	"I can't do it like that.",
	"I tried, no luck."
]

func randomItemFailMessage() -> String:
	var i: int = randi() % itemFailMessages.size()
	return itemFailMessages[i]
	
var gameOverMessages: Array = [
	"YOU DONE MESSED UP A-A-RON!",
	"AHHHHHHH!",
	"Well the good news is... Actually nevermind, there is no good news.",
	"GET REKT!",
	"WHAT'D YOU DO?!",
	"OH YOU DONE DID IT NOW!",
	"YOU'VE YEE'D YER LAST HAW!",
	"WHY WOULD YOU EVEN TRY THAT?!",
	"You did this to yourself.",
	"F's in chat.",
	"You'll get it next time!",
	"I trust you... I TRUST THAT YOU WILL FAIL!",
	"I believe in you... I BELIEVE THAT YOU GOT REKT!",
	"What if we don't do that next time?",
	"Have you tried not doing that?",
	"GET DONK'D ON!",
	"GET STYLED UPON FOOL!",
	"I GOT SO FAR, AND TRIED SO HARD... BUT IN THE END, IT DIDN'T EVEN MATTER!",
	"I give that fail a solid 4/10. Good job.",
	"Perched at the very precipice of oblivion...",
	"Survival is a tenuous proposition in this sprawling tomb...",
	"True desperation is known only when escape is impossible..."
]

func randomGameOverMessage() -> String:
	var i: int = randi() % gameOverMessages.size()
	return gameOverMessages[i]
	
var gameOverSounds: Array = [
	"res://sounds/gameover1.ogg",
	"res://sounds/gameover2.ogg",
	"res://sounds/gameover3.ogg",
	"res://sounds/gameover4.ogg",
	"res://sounds/gameover5.ogg",
	"res://sounds/gameover6.ogg",
]

func randomGameOverSound() -> String:
	var i: int = randi() % gameOverSounds.size()
	return gameOverSounds[i]

func addEntryToChatLog(entry: String, entryType: String) -> void:
	get_tree().root.get_node("Main/UICanvasLayer/ChatLog").addEntry(entry, entryType)


# Here are the various events we can call for various interactions
func busted(sceneTree: SceneTree) -> void:
	# In this event, Shrank busts through a door and busts the player causing a restart.
	var room: Node2D = sceneTree.root.get_node("Main/Room")
	var main: Node2D = sceneTree.root.get_node("Main")
	# Hide the light from the cursor
	main.cursor.hideLight()
	# Play a message that something went wrong
	addEntryToChatLog(randomGameOverMessage(), "fail")
	var spr: Sprite = Sprite.new()
	spr.texture = load("res://sprites/GWJ71Shrenk.png")
	# Shrank is actually kinda big lol
	spr.scale = Vector2(3,3)
	# Add a light to Shrank as well
	var light: Light2D = Light2D.new()
	light.texture = load("res://sprites/GWJ71_lightmask.png")
	light.energy = 1
	light.texture_scale = 5
	spr.add_child(light)
	# Add to scene
	room.add_child(spr)
	# Set position
	spr.global_position = Vector2(160,130)
	# Play his sound
	AudioManager.playSound(randomGameOverSound())
	# Create the sprite for our WASTED screen
	var spr2: Sprite = Sprite.new()
	spr2.texture = load("res://sprites/GWJ71_wasted.png")
	# Start it out as transparent
	spr2.modulate.a = 0
	# Add it to the scene
	room.add_child(spr2)
	spr2.global_position = Vector2(160,90)
	# Set up a Tween to make our endgame effect
	var tween: Tween = Tween.new()
	# Let's interpolate the size of Shrank
	tween.interpolate_property(
		spr, 
		"scale", 
		Vector2(3,3), 
		Vector2(8,8),
		3, 
		Tween.TRANS_BOUNCE, 
		Tween.EASE_OUT
	)
	# We need to interpolate his position too to make it go to the center of the screen.
	tween.interpolate_property(
		spr,
		"global_position",
		spr.global_position,
		Vector2(160, 90),
		3,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	# Let's interpolate the alpha of the end screen
	tween.interpolate_property(
		spr2, 
		"modulate", 
		Color(1,1,1,0), 
		Color(1,1,1,1), 
		5, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN
	)
	# Add it to the room
	room.add_child(tween)
	# Start the tween
	tween.start()
	# Connect the signal
	tween.connect("tween_all_completed", self, "_reset", [main])
	# Ensure our stuff can't be paused
	spr.pause_mode = Node.PAUSE_MODE_PROCESS
	spr2.pause_mode = Node.PAUSE_MODE_PROCESS
	tween.pause_mode = Node.PAUSE_MODE_PROCESS
	# Clear the descrption
	clearDesc(sceneTree)
	# Pause everything else so we can't do stuff in it
	sceneTree.paused = true

func _reset(main: Node2D) -> void:
	# Reset GameState
	GameState.resetGameState()
	# Prepare the room
	main.prepareRoom()
	# Reset cursors
	main.updateCursors()

func _victory(main: Node2D) -> void:
	main.clearScene()

func updateHoverLabel(text: String, clear: bool, sceneTree: SceneTree) -> void:
	# Get the main node from the scene tree
	var main: Node2D = sceneTree.root.get_node("Main")
	# Are we clearing text or setting it?
	if clear:
		main.descLabel.clearText(text)
	else:
		main.descLabel.setText(text)

func clearDesc(sceneTree: SceneTree) -> void:
	# Get the main node from the scene tree
	var main: Node2D = sceneTree.root.get_node("Main")
	main.descLabel.forceClearText()

func exploded(sceneTree: SceneTree) -> void:
	# In this event we detonate the nuke while we're next to it.
	var room: Node2D = sceneTree.root.get_node("Main/Room")
	var main: Node2D = sceneTree.root.get_node("Main")
	# Hide the light from the cursor
	main.cursor.hideLight()
	# Play a message that something went wrong
	addEntryToChatLog(randomGameOverMessage(), "fail")
	var spr: Sprite = Sprite.new()
	spr.texture = load("res://sprites/GWJ71mushroomcloud.png")
	# Add a light to mushroom cloud as well
	var light: Light2D = Light2D.new()
	light.texture = load("res://sprites/GWJ71_lightmask.png")
	light.energy = 1
	light.texture_scale = 5
	spr.add_child(light)
	# Add to scene
	room.add_child(spr)
	# Set position
	spr.global_position = Vector2(160,130)
	# Play sploder sound
	AudioManager.playSound("res://sounds/b-b-boom.ogg")
	# Create the sprite for our WASTED screen
	var spr2: Sprite = Sprite.new()
	spr2.texture = load("res://sprites/GWJ71_wasted.png")
	# Start it out as transparent
	spr2.modulate.a = 0
	# Add it to the scene
	room.add_child(spr2)
	spr2.global_position = Vector2(160,90)
	# Set up a Tween to make our endgame effect
	var tween: Tween = Tween.new()
	# Let's interpolate the size of the mushroom cloud
	tween.interpolate_property(
		spr, 
		"scale", 
		Vector2(1,1), 
		Vector2(8,8),
		2, 
		Tween.TRANS_BOUNCE, 
		Tween.EASE_OUT
	)
	# We need to interpolate his position too to make it go to the center of the screen.
	tween.interpolate_property(
		spr,
		"global_position",
		spr.global_position,
		Vector2(160, 90),
		3,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	# Let's interpolate the alpha of the end screen
	tween.interpolate_property(
		spr2, 
		"modulate", 
		Color(1,1,1,0), 
		Color(1,1,1,1), 
		5, 
		Tween.TRANS_BOUNCE, 
		Tween.EASE_IN
	)
	# Add it to the room
	room.add_child(tween)
	# Start the tween
	tween.start()
	# Connect the signal
	tween.connect("tween_all_completed", self, "_reset", [main])
	# ensure our stuff can't be paused
	spr.pause_mode = Node.PAUSE_MODE_PROCESS
	spr2.pause_mode = Node.PAUSE_MODE_PROCESS
	tween.pause_mode = Node.PAUSE_MODE_PROCESS
	# Clear the descrption
	clearDesc(sceneTree)
	# Pause everything else so we can't do stuff in it
	sceneTree.paused = true

# Victory!
func victory(sceneTree: SceneTree) -> void:
	# In this event Grayman spirals out into the sky while cackling.
	# Why? Because it would be funny
	# Oh and then it fades to black
	var room: Node2D = sceneTree.root.get_node("Main/Room")
	var main: Node2D = sceneTree.root.get_node("Main")
	# Hide the light from the cursor
	main.cursor.hideLight()
	# Play a message that something went wrong
	addEntryToChatLog("FREEDOM! What the... Whatever, I'm free! You win the Game!", "dialogue")
	var spr: Sprite = load("res://rooms/GrayManEnd.tscn").instance()
	spr.texture = load("res://sprites/GWJ71grayman.png")
	# Add a light to grayman as well
	var light: Light2D = Light2D.new()
	light.texture = load("res://sprites/GWJ71_lightmask.png")
	light.energy = 1
	light.texture_scale = 5
	spr.add_child(light)
	# Add to scene
	room.add_child(spr)
	# Set position
	spr.global_position = Vector2(160,130)
	# Play sploder sound
	AudioManager.playSound("res://sounds/greymanclick.ogg")
	# Create the sprite for our WASTED screen
	var spr2: Sprite = Sprite.new()
	spr2.texture = load("res://sprites/GWJ71_victory.png")
	# Start it out as transparent
	spr2.modulate.a = 0
	# Add it to the scene
	room.add_child(spr2)
	spr2.global_position = Vector2(160,90)
	# Set up a Tween to make our endgame effect
	var tween: Tween = Tween.new()
	# Let's interpolate the size of the mushroom cloud
	tween.interpolate_property(
		spr, 
		"scale", 
		Vector2(8,8), 
		Vector2(0,0),
		3, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_OUT
	)
	# We need to interpolate his position too to make it go to the center of the screen.
	tween.interpolate_property(
		spr,
		"global_position",
		spr.global_position,
		Vector2(160, 90),
		3,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	# Let's interpolate the alpha of the end screen
	tween.interpolate_property(
		spr2, 
		"modulate", 
		Color(1,1,1,0), 
		Color(1,1,1,1), 
		5, 
		Tween.TRANS_BOUNCE, 
		Tween.EASE_IN
	)
	# Add it to the room
	room.add_child(tween)
	# Start the tween
	tween.start()
	# Connect the signal
	tween.connect("tween_all_completed", self, "_victory", [main])
	# ensure our stuff can't be paused
	spr.pause_mode = Node.PAUSE_MODE_PROCESS
	spr2.pause_mode = Node.PAUSE_MODE_PROCESS
	tween.pause_mode = Node.PAUSE_MODE_PROCESS
	# Clear the descrption
	clearDesc(sceneTree)
	# Pause everything else so we can't do stuff in it
	sceneTree.paused = true
