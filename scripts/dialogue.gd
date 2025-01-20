extends Node2D

@onready var textn: int = 0
@export var texts: Array[String]
@export var speakers: Array[int]
@onready var label := $Label
@onready var progress := 0.0
@onready var anim = $AnimatedSprite2D
@onready var tm = TransitionManager.get_node("Node2D")

func _ready():
	if get_tree().current_scene.name in GlobalVariables.dialogue_passed:
		queue_free()
		return
	label.text = texts[textn]
	anim.animation = "sci" + str(speakers[textn] + 1)

func _process(delta):
	if textn >= len(texts):
		visible = false
		if texts[textn - 1] == "Alright, but when things get out of hand, we'll take action.":
			tm.next_level("res://level_1.tscn")
		#GlobalVariables.dialogue_passed.append(get_tree().current_scene.name)
		return
	progress += 30 * delta
	label.visible_characters = int(progress)
	if progress >= 60 + len(label.text):
		textn += 1
		progress = 0
		label.visible_characters = 0
		if textn < len(texts):
			label.text = texts[textn]
			anim.animation = "sci" + str(speakers[textn] + 1)

func clear():
	textn = 0
	texts.clear()
	speakers.clear()
	progress = 0
	label.visible_characters = 0
	label.text = ''
	visible = true

func switch(t, s):
	clear()
	texts = t
	speakers = s
	label.text = texts[textn]
	anim.animation = "sci" + str(speakers[textn] + 1)
