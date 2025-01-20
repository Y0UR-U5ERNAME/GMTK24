extends StaticBody2D

@export var id: int
@onready var unlocking := false
@onready var entered := false
@onready var tounlock = $ToUnlock

func _ready():
	if id in GlobalVariables.unlocked:
		queue_free()
	else:
		scale.x = 1
		$Area2D.connect("body_entered", on_enter)
		$Area2D.connect("body_exited", on_exit)
		tounlock.visible = false

func _process(delta):
	if unlocking:
		scale.x *= .7 ** 60 ** delta
		if scale.x < .05:
			queue_free()
	elif entered and id in GlobalVariables.inventory and Input.is_action_just_pressed("interact"):
		unlock()

func unlock():
	unlocking = true
	GlobalVariables.unlocked.append(id)
	GlobalVariables.inventory.erase(id)

func on_enter(_body):
	entered = true
	if (id in GlobalVariables.inventory):
		tounlock.visible = true

func on_exit(_body):
	entered = false
	tounlock.visible = false
