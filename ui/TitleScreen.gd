extends Node2D


func _on_Button_pressed():
	var main: Node2D = load("res://Main.tscn").instance()
	get_tree().root.add_child(main)
	queue_free()
