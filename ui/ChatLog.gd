extends Control


# We need to manage a reference to where we add stuff to
onready var chat: VBoxContainer = $MC/VBC
var colorEvent: Color = Color.yellow
var colorDialogue: Color = Color.lime
var colorFail: Color = Color.red

# I only want a few entries at a time
var maxEntries: int = 2
var entries: Array = []

# Add a new entry into the chatlog
func addEntry(text: String, entryType: String) -> void:
	# Create a new label
	var label: Label = Label.new()
	# Set the text
	label.text = text
	# Set the color if needed
	match entryType:
		"event":
			label.modulate = colorEvent
		"dialogue":
			label.modulate = colorDialogue
		"fail":
			label.modulate = colorFail
		_:
			label.modulate = Color(1,1,1)
	# Add a tween to the label
	var tween: Tween = Tween.new()
	label.add_child(tween)
	# Add the label to the chat
	chat.add_child(label)
	# Set the tween to fade out the alpha
	tween.interpolate_property(
		label, 
		"modulate", 
		Color(label.modulate.r,label.modulate.g,label.modulate.b,1), 
		Color(label.modulate.r,label.modulate.g,label.modulate.b,0), 
		10, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN
	)
	# Connect the signal when the tween is done so we can delete the entry.
	tween.connect("tween_all_completed", self, "removeEntry", [label])
	# Start the tween
	tween.start()
	# Add it to the entries array
	entries.append(label)
	# Do we need to remove any old entries that are still hanging around?
	if entries.size() > maxEntries:
		# Yes, remove the first index
		removeEntry(entries[0])
		entries.pop_front()


# Destroy faded entry
func removeEntry(entry: Label) -> void:
	if is_instance_valid(entry):
		entry.queue_free()
