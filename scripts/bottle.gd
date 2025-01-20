extends Node2D

@onready var area2d = $Area2D
@onready var player = get_parent()
@onready var player_sprite = get_parent().get_node("Sprite2D")
var level := 0.0
const MAX_LEVEL := 32*64*2.
@onready var cooldown := 0.0
@onready var scene = get_tree().current_scene
const drop = preload("res://drop.tscn")

func _ready():
	level = GlobalVariables.bottle_level
	position += Vector2(-8 if player_sprite.flip_h else 8, -32)

func _process(delta):
	position.x = -8 if player_sprite.flip_h else 8
	rotation = global_position.angle_to_point(get_global_mouse_position())
	area2d.global_position = get_global_mouse_position()
	
	var o = area2d.get_overlapping_areas()
	if o and area2d.global_position.distance_to(global_position) <= 128 and Input.is_action_pressed("bottle_collect"):
		var w
		if o[0] is SavePoint: w = o[0]
		else: w = o[0].get_parent().get_parent()
		var changed = level + 5.*32*64/player.limit * delta
		if changed > MAX_LEVEL: changed = MAX_LEVEL
		level += w.drain(changed - level)
		GlobalVariables.bottle_level = level
	elif Input.is_action_pressed("bottle_absorb"):
		var changed = level - 5.*32*64/player.limit * delta
		if changed < 0: changed = 0
		level += player.drain(changed - level)
		GlobalVariables.bottle_level = level
	elif Input.is_action_pressed("bottle_release"):
		if cooldown == 0:
			var changed = level - 10.*32*64/player.limit * delta
			if changed < 0:
				changed = 0
			else:
				cooldown = 0.1
				var d = drop.instantiate()
				d.rotation = rotation
				scene.add_child(d)
				d.global_position = global_position
			level = changed
			GlobalVariables.bottle_level = level
	
	cooldown = max(0, cooldown - delta)
