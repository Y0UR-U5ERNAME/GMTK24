extends Node

@onready var player_size := 1.0
@onready var save_data = null
@onready var dialogue_passed = []
@onready var inventory = []
@onready var unlocked = []
@onready var collected = []
@onready var tm = TransitionManager.get_node("Node2D")
@onready var bottle_level = 0.0

func save():
	var scene = PackedScene.new()
	scene.pack(get_tree().current_scene)
	if get_tree().current_scene.name != "Level1":
		var s = preload("res://collect_sound.tscn").instantiate()
		get_tree().current_scene.add_child.call_deferred(s)
	save_data = [
		scene,
		player_size,
		get_tree().current_scene.scene_file_path,
		dialogue_passed.duplicate(),
		inventory.duplicate(),
		unlocked.duplicate(),
		collected.duplicate(),
		bottle_level
	]

func load_save():
	player_size = save_data[1]
	dialogue_passed = save_data[3].duplicate()
	inventory = save_data[4].duplicate()
	unlocked = save_data[5].duplicate()
	collected = save_data[6].duplicate()
	bottle_level = save_data[7]
	tm.start_dir = 0
	get_tree().change_scene_to_packed(save_data[0])
