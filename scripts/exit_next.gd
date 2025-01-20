extends Area2D

@onready var tm = TransitionManager.get_node("Node2D")
@export var to_scene: String = ""

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	tm.next_level(to_scene)
	body.set_tm_pos()
	var n = get_tree().current_scene.name
	if n not in GlobalVariables.dialogue_passed:
		GlobalVariables.dialogue_passed.append(n)
