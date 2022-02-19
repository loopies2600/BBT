extends Sprite

const TITLES := [Rect2(16, 19, 59, 51), Rect2(16, 82, 61, 45)]
const DESCRIPTIONS := [Rect2(18, 27, 62, 64), Rect2(18, 103, 59, 53)]

onready var title := $Title
onready var desc := $Description

var mode := 0

func _process(delta):
	title.region_rect = TITLES[mode]
	desc.region_rect = DESCRIPTIONS[mode]
	
	position = lerp(position, Vector2(0, 0) if get_parent().get_parent().get_parent().editing else Vector2(96, 0), 16 * delta)
