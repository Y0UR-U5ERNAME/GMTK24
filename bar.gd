extends TextureProgressBar

@onready var pb = $ProgressBar
@onready var tpb = $TextureProgressBar
@onready var tpbpb = $TextureProgressBar/ProgressBar
@onready var frame = $ItemFrame
@onready var sprite = $ItemFrame/Sprite2D
@onready var items = []

func _ready():
	if 1 not in GlobalVariables.inventory:
		tpb.visible = false
	if len(GlobalVariables.inventory) == (1 if 1 in GlobalVariables.inventory else 0):
		frame.visible = false
	for i in range(3):
		items.append(load("res://graphics/item" + str(i) + ".png"))
	pb.value = value
	tpb.value = GlobalVariables.bottle_level / 4096 * 100
	tpbpb.value = tpb.value

func _process(_delta):
	pb.value = value
	tpb.value = GlobalVariables.bottle_level / 4096 * 100
	tpbpb.value = tpb.value
	if not tpb.visible:
		if 1 in GlobalVariables.inventory:
			tpb.visible = true
	if len(GlobalVariables.inventory) > (1 if 1 in GlobalVariables.inventory else 0):
		frame.visible = true
		for i in GlobalVariables.inventory:
			if i != 1:
				sprite.texture = items[i]
				break
	else:
		frame.visible = false
