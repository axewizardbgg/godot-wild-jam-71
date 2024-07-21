extends MenuButton

# We need to be able to send additional data when we are pressed!
signal itemEntryPressed(item)


func _on_MenuButton_pressed():
	# We've been clicked, so let's emit our custom signal so ItemSelection knows
	# what button was actually clicked
	emit_signal("itemEntryPressed", text) # text should be set by the calling instance
