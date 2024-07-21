extends Node


func playSound(sndPath: String):
	# Create a new player
	var sndPlayer: AudioStreamPlayer = AudioStreamPlayer.new()
	sndPlayer.pause_mode = Node.PAUSE_MODE_PROCESS
	# Set the sound
	sndPlayer.stream = load(sndPath)
	# Add it to the scene
	get_tree().root.add_child(sndPlayer)
	# Connect signal of when it is finished.
	sndPlayer.connect("finished", self, "_sndDone", [sndPlayer])
	# Play the sound
	sndPlayer.play()

func _sndDone(sndPlayer: AudioStreamPlayer):
	if is_instance_valid(sndPlayer):
		sndPlayer.queue_free()
