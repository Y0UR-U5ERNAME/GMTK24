extends CharacterBody2D

func _ready():
	velocity = 300 * Vector2.from_angle(rotation)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
	if get_slide_collision_count():
		for i in get_slide_collision_count():
			var c = get_slide_collision(i).get_collider()
			if c is Subject2:
				# use 1/30 to shrink by 2/30
				c.scale.x -= 2./30 * delta
				if c.scale.x < 0: c.scale.x = 0
				c.scale.y = c.scale.x
				if c.scale.x == 0: c.die()
		queue_free()
	
	rotation = velocity.angle()
