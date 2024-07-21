extends Node

# This is where we track all the state for this simple game. Not ideal to have
# it all as a global autoload, but whatever, I got 9 days! Get off my back

var initial: Dictionary = {
	"inventory": [],
	"currentRoom": "room1",
	"nukeExploded": false,
	"gearsFixed": false,
	"leverOn": false,
	# Room State
	"rooms": {
		# Starter room
		"room1": {
			"sprPath": "res://sprites/GWJ71_320x180_Wood.png",
			"flipped": false,
			"decor": [
				{
					"sprPath": "res://sprites/GWJ71_table.png",
					"globalPos": Vector2(76,136),
					"flipped": false
				}
			],
			"doors": [
				{
					"desc": "A sturdy-looking Wooden Door. Might be able to force it open...",
					"sprPathOpen": "res://sprites/GWJ71_FrontDoorOpen.png",
					"sprPathClosed": "res://sprites/GWJ71_FrontDoor.png",
					"globalPos": Vector2(160,111),
					"open": false,
					"flipped": false,
					"whereTo": "room2",
					"usableItems": ["Worn Key", "Crowbar"],
					"preferredItem": "Worn Key",
					"wrongItemEventName": "busted"
				},
			],
			"items": [
				{
					"scenePath": "res://items/ItemCrowbar.tscn",
					"globalPos": Vector2(86, 145)
				}
			],
			"interactables": [
				{
					"scenePath": "res://interactables/BarrelWornKey.tscn",
					"globalPos": Vector2(245, 132)
				},
				{
					"scenePath": "res://interactables/HangingChain.tscn",
					"globalPos": Vector2(85, 20),
				},
				{
					"scenePath": "res://interactables/CrateCushion.tscn",
					"globalPos": Vector2(287, 157),
				},
				{
					"scenePath": "res://interactables/CrateTorch.tscn",
					"globalPos": Vector2(31, 157),
				},
				{
					"scenePath": "res://interactables/Candle.tscn",
					"globalPos": Vector2(60, 115)
				}
			],
		},
		# Where the Gate and FlaMANgo is
		"room2": {
			"sprPath": "res://sprites/GWJ71_320x180_Stone.png",
			"flipped": false,
			"decor": [
				{
					"sprPath": "res://sprites/GWJ71Lantern.png",
					"globalPos": Vector2(103,89),
					"flipped": false
				},
				{
					"sprPath": "res://sprites/GWJ71Lantern.png",
					"globalPos": Vector2(209,89),
					"flipped": false
				},
			],
			"doors": [
				{
					"desc": "A heavy Gate, hopefully it's the way out of here?",
					"sprPathOpen": "res://sprites/GWJ71_gateopen.png",
					"sprPathClosed": "res://sprites/GWJ71_gateclosed.png",
					"globalPos": Vector2(160,102),
					"open": false,
					"side": false,
					"flipped": false,
					"whereTo": "room6",
					"usableItems": [""],
					"preferredItem": "",
					"wrongItemEventName": "busted"
				},
				{
					"desc": "Another Wooden Door. Thanks, I hate it.",
					"sprPathOpen": "res://sprites/GWJ71_SideDoorOpen.png",
					"sprPathClosed": "res://sprites/GWJ71_SideDoor.png",
					"globalPos": Vector2(35,125),
					"open": false,
					"flipped": true,
					"whereTo": "room5",
					"usableItems": ["Dull Key", "Crowbar"],
					"preferredItem": "Dull Key",
					"wrongItemEventName": "busted"
				},
				{
					"desc": "It's a Door, rumor is these things can open or something.",
					"sprPathOpen": "res://sprites/GWJ71_SideDoorOpen.png",
					"sprPathClosed": "res://sprites/GWJ71_SideDoor.png",
					"globalPos": Vector2(286,125),
					"open": false,
					"flipped": false,
					"whereTo": "room3",
					"usableItems": ["Worn Key", "Crowbar"],
					"preferredItem": "Worn Key",
					"wrongItemEventName": "busted"
				},
				{
					"desc": "This goes back to the previous Room.",
					"sprPathOpen": "res://sprites/GWJ71_DoorBack.png",
					"sprPathClosed": "",
					"globalPos": Vector2(160,178),
					"open": true,
					"flipped": false,
					"whereTo": "room1",
					"usableItems": [],
					"preferredItem": "",
					"wrongItemEventName": "busted"
				},
			],
			"items": [
				{
					"scenePath": "res://items/ItemBroom.tscn",
					"globalPos": Vector2(80,138),
				}
			],
			"interactables": [
				{
					"scenePath": "res://interactables/Flamango.tscn",
					"globalPos": Vector2(230,138),
				}
			],
		},
		# Room off the right of the Main Gate area
		"room3": {
			"sprPath": "res://sprites/GWJ71_320x180_Stone.png",
			"flipped": true,
			"decor": [
				{
					"sprPath": "res://sprites/GWJ71_table.png",
					"globalPos": Vector2(245,136),
					"flipped": true
				},
				{
					"sprPath": "res://sprites/GWJ71_shelf.png",
					"globalPos": Vector2(82,102),
					"flipped": false
				},
				{
					"sprPath": "res://sprites/GWJ71Lantern.png",
					"globalPos": Vector2(160,89),
					"flipped": false
				},
				{
					"sprPath": "res://sprites/GWJ71barrelopen.png",
					"globalPos": Vector2(150,134),
					"flipped": false
				}
			],
			"doors": [
				{
					"desc": "A Ladder descends into darkness...",
					"sprPathOpen": "res://sprites/GWJ71_LadderDown.png",
					"sprPathClosed": "",
					"globalPos": Vector2(254,162),
					"open": true,
					"flipped": true,
					"whereTo": "room4",
					"usableItems": [],
					"preferredItem": "",
					"wrongItemEventName": "busted"
				},
				{
					"desc": "Yo I just came this way bruh.",
					"sprPathOpen": "res://sprites/GWJ71_SideDoorOpen.png",
					"sprPathClosed": "res://sprites/GWJ71_SideDoor.png",
					"globalPos": Vector2(35,125),
					"open": true,
					"flipped": true,
					"whereTo": "room2",
					"usableItems": [],
					"preferredItem": "",
					"wrongItemEventName": "busted"
				},
			],
			"items": [
				{
					"scenePath": "res://items/ItemRope.tscn",
					"globalPos": Vector2(235, 116)
				}
			],
			"interactables": [
				{
					"scenePath": "res://interactables/Chest.tscn",
					"globalPos": Vector2(82,100),
				},
				{
					"scenePath": "res://interactables/BarrelWater.tscn",
					"globalPos": Vector2(180,134),
				},
				{
					"scenePath": "res://interactables/Rat.tscn",
					"globalPos": Vector2(100,170),
				}
			],
		},
		# Room that is down the ladder off the right room.
		"room4": {
			"sprPath": "res://sprites/GWJ71_320x180_Wood.png",
			"flipped": true,
			"decor": [
				{
					"sprPath": "res://sprites/GWJ71_shelf.png",
					"globalPos": Vector2(82,102),
					"flipped": false
				},
			],
			"doors": [
				{
					"desc": "Back into the light...",
					"sprPathOpen": "res://sprites/GWJ71_LadderUp.png",
					"sprPathClosed": "",
					"globalPos": Vector2(242,89),
					"open": true,
					"flipped": true,
					"whereTo": "room3",
					"usableItems": [],
					"preferredItem": "",
					"wrongItemEventName": "busted"
				},
			],
			"items": [
				{
					"scenePath": "res://items/ItemLockpick.tscn",
					"globalPos": Vector2(82, 102)
				},
				{
					"scenePath": "res://items/ItemLongPipe.tscn",
					"globalPos": Vector2(55, 150)
				},
				
			],
			"interactables": [
				{
					"scenePath": "res://interactables/SkeleBoi.tscn",
					"globalPos": Vector2(140, 130),
				},
				{
					"scenePath": "res://interactables/CrateTools.tscn",
					"globalPos": Vector2(287, 157),
				},
				{
					"scenePath": "res://interactables/Nuke.tscn",
					"globalPos": Vector2(160, 155),
				},
			],
		},
		# Room that is to the left of the Gate room.
		"room5": {
			"sprPath": "res://sprites/GWJ71_320x180_Stone.png",
			"flipped": true,
			"decor": [
				{
					"sprPath": "res://sprites/GWJ71Lantern.png",
					"globalPos": Vector2(160,89),
					"flipped": false
				},
			],
			"doors": [
				{
					"desc": "The Ogre opened this for me... I have to get out of here fast.",
					"sprPathOpen": "res://sprites/GWJ71_SideDoorOpen.png",
					"sprPathClosed": "",
					"globalPos": Vector2(286,125),
					"open": true,
					"flipped": false,
					"whereTo": "room2",
					"usableItems": [],
					"preferredItem": "",
					"wrongItemEventName": "busted"
				},
			],
			"items": [

			],
			"interactables": [
				{
					"scenePath": "res://interactables/SlimeBoi.tscn",
					"globalPos": Vector2(65, 125),
				},
				{
					"scenePath": "res://interactables/Anvil.tscn",
					"globalPos": Vector2(60, 145),
				},
				{
					"scenePath": "res://interactables/Gears.tscn",
					"globalPos": Vector2(220, 100),
				},
				{
					"scenePath": "res://interactables/Switch.tscn",
					"globalPos": Vector2(140, 100),
				},
			],
		},
		# The victory room!
		"room6": {
			"sprPath": "res://sprites/GWJ71_320x180_Outside.png",
			"flipped": false,
			"decor": [

			],
			"doors": [
				
			],
			"items": [

			],
			"interactables": [

			],
		},
	}
}

# This is the actual game state, we initialize it as the initial, and we can reset
# it at will with "resetGameState()"
var current: Dictionary = initial.duplicate(true)

# Typically used when you wish to restart the game
func resetGameState():
	# Set our gameState to be our initialGameState
	current = {}
	current = initial.duplicate(true)

	
