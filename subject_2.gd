extends CharacterBody2D
class_name Subject2

const BASE_SPEED = 200.0
var SPEED = BASE_SPEED
const JUMP_VELOCITY = -400.0
const CRUSH_TOLERANCE := 0.8
@export var direction = 1
@onready var left = $RayCastLeft
@onready var right = $RayCastRight
@onready var sprite = $AnimatedSprite2D

func _ready():
	direction = 1
	sprite.play()

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	#SPEED = BASE_SPEED * scale.x
	SPEED = BASE_SPEED * .5
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var pre_scale = scale
	scale *= .99
	move_and_slide()
	scale = pre_scale
	if direction == -1 and left.is_colliding() or direction == 1 and right.is_colliding():
		direction *= -1
	
	if velocity.x > 0: sprite.flip_h = false
	elif velocity.x < 0: sprite.flip_h = true
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i).get_collider()
		if c is Player:
			var changed = scale.x + 2./30 * delta
			var change = c.drain((changed * changed - scale.x * scale.y) * 64 * 32)
			changed = sqrt(scale.x * scale.y + change/32/64)
			scale = Vector2(changed, changed)
			break
		
	pre_scale = scale
	scale *= CRUSH_TOLERANCE
	if test_move(transform, Vector2.ZERO) and (\
		test_move(transform, Vector2.LEFT) and test_move(transform, Vector2.RIGHT)\
		or test_move(transform, Vector2.UP) and test_move(transform, Vector2.DOWN)):
		die()
	scale = pre_scale

func die():
	visible = false
	$CollisionShape2D.disabled = true
	var de = preload("res://death_effect.tscn").instantiate()
	de.global_position = global_position + Vector2(0, -8) * scale.y
	get_tree().current_scene.add_child(de)
	queue_free()
