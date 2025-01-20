extends Node2D

@onready var rect = $ColorRect
enum {
	NO_TRANSITION,
	TRANSITION_IN,
	TRANSITION_OUT,
	TRANSITION_CIRCLE_IN,
	TRANSITION_CIRCLE_OUT
}
var transition
const SPEED = 700
const CIRCLE_SPEED = 500
var to_scene = null
@onready var curr_scene = get_tree().current_scene.scene_file_path
var start_dir = 1

func _ready():
	if not curr_scene: curr_scene = GlobalVariables.save_data[2]
	visible = true
	transition = TRANSITION_CIRCLE_IN
	rect.material["shader_parameter/size"] = 0
	if get_tree().current_scene.name.substr(0, 5) != "Level":
		rect.material["shader_parameter/pos"] = Vector2(480./2, 320./2)
	get_tree().paused = false

func _process(delta):
	match transition:
		NO_TRANSITION:
			pass
		TRANSITION_IN: # 0 to 320
			if position.y >= 320:
				transition = NO_TRANSITION
			position.y += SPEED * delta
			position.y = min(320, position.y)
		TRANSITION_OUT: # -320 to 0
			if position.y >= 0:
				position.y = 0
				transition = NO_TRANSITION
				if to_scene: get_tree().change_scene_to_file(to_scene)
				else: GlobalVariables.load_save()
			position.y += SPEED * delta
			position.y = min(0, position.y)
		TRANSITION_CIRCLE_IN:
			if rect.material["shader_parameter/size"] >= Vector2(480, 320).length() + 1:
				transition = NO_TRANSITION
			rect.material["shader_parameter/size"] += CIRCLE_SPEED * delta
		TRANSITION_CIRCLE_OUT:
			if rect.material["shader_parameter/size"] <= 0:
				transition = NO_TRANSITION
				if to_scene: get_tree().change_scene_to_file(to_scene)
				else: GlobalVariables.load_save()
			rect.material["shader_parameter/size"] -= CIRCLE_SPEED * delta

func change_scene_to_file(scene, t=TRANSITION_OUT):
	get_tree().paused = true
	if t == TRANSITION_CIRCLE_OUT:
		rect.material["shader_parameter/size"] = Vector2(480, 320).length() + 1
		position.y = 0
	else:
		position.y = -320
		rect.material["shader_parameter/size"] = 0
	transition = t
	to_scene = scene

func restart():
	change_scene_to_file(null, TRANSITION_CIRCLE_OUT)

func next_level(path=""):
	start_dir = 1
	if not path:
		#var sub = curr_scene.substr(0, curr_scene.length()-5) # res://level_1
		#var num = int(sub.substr(12)) # 1
		var num = int(get_tree().current_scene.name.substr(5))
		path = "res://level_" + str(num + 1) + ".tscn"
	if ResourceLoader.exists(path):
		change_scene_to_file(path, TRANSITION_CIRCLE_OUT)
	else:
		change_scene_to_file("res://level_1.tscn", TRANSITION_CIRCLE_OUT)

func prev_level(path=""):
	start_dir = -1
	if not path:
		#var sub = curr_scene.substr(0, curr_scene.length()-5) # res://level_1
		#var num = int(sub.substr(12)) # 1
		var num = int(get_tree().current_scene.name.substr(5))
		path = "res://level_" + str(num - 1) + ".tscn"
	if ResourceLoader.exists(path):
		change_scene_to_file(path, TRANSITION_CIRCLE_OUT)
	else:
		change_scene_to_file("res://level_1.tscn", TRANSITION_CIRCLE_OUT)
