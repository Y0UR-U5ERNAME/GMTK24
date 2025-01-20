extends Area2D
class_name Collectible

@export var id: int
var start_pos: Vector2
@onready var time = 0.0

func _ready():
	if id in GlobalVariables.collected: queue_free()
	else:
		connect("body_entered", _on_body_entered)
		start_pos = position

func _process(delta):
	position = start_pos + Vector2.UP * sin(time * 5)
	time = fmod(time + delta, 2*PI)

func collect(_body):
	pass

func _on_body_entered(body):
	collect(body)
	var s = preload("res://collect_sound.tscn").instantiate()
	get_tree().current_scene.add_child(s)
	GlobalVariables.inventory.append(id)
	GlobalVariables.collected.append(id)
	queue_free()
