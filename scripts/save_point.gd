extends Area2D
class_name SavePoint

@onready var sprite = $Sprite2D

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	sprite.visible = false

func _on_body_entered(body):
	body.in_water = self
	body.can_save = true
	sprite.visible = true

func _on_body_exited(body):
	body.in_water = null
	body.can_save = false
	sprite.visible = false

func drain(amount):
	return amount
