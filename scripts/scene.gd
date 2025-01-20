extends Node2D
class_name Scene

@onready var tm = get_tree().root.get_node("TransitionManager/Node2D")

func _ready():
	tm._ready()
