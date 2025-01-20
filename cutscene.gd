extends Scene

@onready var d = $CanvasLayer/Dialogue
var switched = false
var switching = false

func _ready():
	super()

func _process(delta):
	if not switched and not switching and d.textn > 3:
		switching = true
	if switching and not switched:
		$CanvasLayer/ColorRect.visible = true
		switched = true
		var a: Array[String] = [
			"...Looks like it headed straight for the underground emergency escape.",
			"Ugh... We'll have to go catch it!",
			"But I want to see what it can do first! Let's monitor it for a while...",
			"Alright, but when things get out of hand, we'll take action."
		]
		var b: Array[int] = [0, 1, 0, 1]
		d.switch(a, b)
