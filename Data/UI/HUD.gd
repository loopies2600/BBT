extends CanvasLayer

onready var tIcons := $TokenIcons
onready var aLabel := $Attempts

func _process(delta):
	aLabel.rect_position.y = lerp(aLabel.rect_position.y, 241 if get_parent().editing else 232, 12 * delta)
	tIcons.position.y = lerp(tIcons.position.y, -8 if get_parent().editing else 2, 12 * delta)
