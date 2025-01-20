extends AnimatedSprite2D

func _ready():
	rotation = randf_range(0, 2 * PI)
	flip_h = randi_range(0, 1)
	play()
	connect("animation_finished", _on_animation_finished)

func _on_animation_finished():
	queue_free()
