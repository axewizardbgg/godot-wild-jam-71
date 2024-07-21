extends Control


# Get the ref to our label
onready var label: Label = $VBC/Label

func setText(text: String) -> void:
	label.text = text

func clearText(text: String) -> void:
	# Only clear the text if that is what is currently being displayed.
	if label.text == text:
		label.text = ""

func forceClearText() -> void:
	label.text = ""
