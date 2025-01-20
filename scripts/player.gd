extends CharacterBody2D
class_name Player

@onready var progress_bar = $"../CanvasLayer/ProgressBar"

const BASE_SPEED := 300.0
const BASE_JUMP_VELOCITY := -500.0
const CRUSH_TOLERANCE := 0.8
var SPEED := BASE_SPEED
var JUMP_VELOCITY := BASE_JUMP_VELOCITY
var limit := 30
var max_size := 1.0
@onready var in_water = null
@onready var can_save := false
@onready var tm = TransitionManager.get_node("Node2D")
@onready var rect = TransitionManager.get_node("Node2D/ColorRect")
@onready var camera = $Camera2D
@onready var sprite = $Sprite2D
const bottle_scene = preload("res://bottle.tscn")

func _ready():
	visible = true
	# TODO: detach altstartpos from player transform
	if tm.start_dir == -1: global_position = $AltStartPos.global_position
	var size = GlobalVariables.player_size
	scale = Vector2(size, size)
	camera.position_smoothing_enabled = false
	camera.force_update_scroll()
	set_tm_pos()
	camera.position_smoothing_enabled = true
	if GlobalVariables.save_data == null: GlobalVariables.save()
		
	if 1 in GlobalVariables.inventory:
		add_bottle()
	
func set_tm_pos():
	camera.force_update_scroll()
	rect.material["shader_parameter/pos"] = get_global_transform_with_canvas().get_origin() + Vector2(0, 64 * -scale.y/2)

func _process(_delta):
	if tm.transition: return
	if Input.is_action_just_pressed("restart"):
		set_tm_pos()
		tm.restart()
	if can_save and Input.is_action_just_pressed("interact"):
		GlobalVariables.save()

func _physics_process(delta):
	if tm.transition == 4 || tm.transition == 2: return
	var s = 2 if Input.is_action_pressed("speedup") else 1
	var changed = scale.x + s * (2. if in_water else -1.)/limit * delta
	# note that player can drain more water if there isnt enough water to drain
	if changed > max_size: changed = max_size
	if in_water: in_water.drain((changed * changed - scale.x * scale.y)*32*64)
	if changed <= 0:
		die()
		return
	resize(changed)
	
	if not is_on_floor():
		velocity += get_gravity() * delta * (0.1 if in_water else 1.)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if velocity.x > 0: sprite.flip_h = false
	elif velocity.x < 0: sprite.flip_h = true
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		if collision.get_collider() is RigidBody2D:
			collision.get_collider().apply_central_impulse(-collision.get_normal() * 6 * scale.x * scale.y)
	
	var pre_scale = scale
	scale *= CRUSH_TOLERANCE
	if test_move(transform, Vector2.ZERO) and (\
		test_move(transform, Vector2.LEFT) and test_move(transform, Vector2.RIGHT)\
		or test_move(transform, Vector2.UP) and test_move(transform, Vector2.DOWN)):
		die()
	scale = pre_scale

func die():
	set_tm_pos()
	tm.restart()
	visible = false
	$CollisionShape2D.disabled = true
	var de = preload("res://death_effect.tscn").instantiate()
	de.global_position = global_position + Vector2(0, -32) * scale.y
	get_tree().current_scene.add_child(de)

func drain(amount):
	# (changed * 32) * (changed * 64) = scale.x * 32 * scale.y * 64 - amount
	var changed = sqrt(scale.x * scale.y - amount/32/64)
	if is_nan(changed):
		var to_return = scale.x * scale.y * 32 * 64
		resize(0)
		return to_return
	else:
		if changed > max_size: changed = max_size
		var to_return = -(changed * changed - scale.x * scale.y) * 32 * 64
		resize(changed)
		return to_return #amount

func resize(changed):
	GlobalVariables.player_size = changed
	scale = Vector2(changed, changed)
	SPEED = BASE_SPEED * changed
	JUMP_VELOCITY = BASE_JUMP_VELOCITY * changed
	progress_bar.value = changed * 100

func add_bottle():
	var b = bottle_scene.instantiate()
	add_child.call_deferred(b)
