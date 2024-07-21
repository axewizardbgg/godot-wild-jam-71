extends Node2D


# Should be declared before we added to scene tree
var lightScale: float = 3
var offset: float = 2
var energy: float = 1

func _ready() -> void:
	$Light2D.texture_scale = lightScale
	$Light2D.energy = energy
	pass # TODO

func _process(_delta: float) -> void:
	$Light2D.position = Vector2(round(rand_range(-offset,offset)),round(rand_range(-offset,offset)))
