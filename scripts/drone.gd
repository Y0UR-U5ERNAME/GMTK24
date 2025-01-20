extends CharacterBody2D

const SPEED := 100.0
const SIZE_LIMIT := 0.3

enum {
	STAY,
	FOLLOW_PATH,
	CHASE
}

@onready var flying := true
@onready var state := FOLLOW_PATH
@onready var direction := 1
@onready var rot_dir := 1
@onready var pathpos = $Node/Path2D/PathFollow2D
@onready var raycasts = $Raycasts
@onready var to_chase = null
@onready var playerraycast = $PlayerRayCast

func _ready():
	var r = raycasts.get_node("RayCast2D")
	const n = 10
	for i in range(1, n + 1):
		var rc = r.duplicate()
		rc.rotation = r.rotation - (r.rotation * 2) * i/n
		raycasts.add_child(rc)

func _physics_process(delta):
	if not flying and not is_on_floor():
		velocity += get_gravity() * delta
		
	match state:
		FOLLOW_PATH:
			if pathpos.progress_ratio == 0 || pathpos.progress_ratio == 1:
				direction *= -1
			pathpos.progress += SPEED * delta * direction
			global_position = pathpos.global_position
		CHASE:
			var dir = global_position.direction_to(to_chase.global_position)
			if abs(dir.x) < 0.01: dir.x = 0
			elif abs(dir.y) < 0.01: dir.y = 0
			velocity = SPEED * dir
			playerraycast.rotation = global_position.angle_to_point(to_chase.global_position + Vector2(0, -to_chase.scale.y * 64/2))
			if to_chase.scale.x <= SIZE_LIMIT or not (playerraycast.is_colliding() and playerraycast.get_collider() is Player):
				state = STAY
				raycasts.visible = true
				raycasts.rotation_degrees = fmod((playerraycast.rotation_degrees + 360 + 180 - 90), 360) - 180
		STAY:
			velocity = SPEED * Vector2.from_angle(playerraycast.rotation)
		
	move_and_slide()
	
	if state == FOLLOW_PATH || state == STAY:
		if raycasts.rotation_degrees <= -90 || raycasts.rotation_degrees >= 90:
			rot_dir *= -1
			raycasts.rotation_degrees = clamp(raycasts.rotation_degrees, -90, 90)
		raycasts.rotation += 1 * rot_dir * delta
		
		for i in raycasts.get_children():
			if i is RayCast2D and i.is_colliding() and i.get_collider() is Player and i.get_collider().scale.x > SIZE_LIMIT:
				state = CHASE
				to_chase = i.get_collider()
				raycasts.visible = false
				break
		if playerraycast.is_colliding() and playerraycast.get_collider() is Player and playerraycast.get_collider().scale.x > SIZE_LIMIT:
			state = CHASE
			to_chase = playerraycast.get_collider()
			raycasts.visible = false
