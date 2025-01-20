extends Area2D

@onready var width: int = $NinePatchRect.size.x
@export var height: int = 16
@onready var start_pos = position

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	body.in_water = self

func _on_body_exited(body):
	body.in_water = null

func drain(amount):
	if position.y - start_pos.y >= height:
		return 0
	position.y += amount/width
	return amount
	# TODO: make water drain properly
