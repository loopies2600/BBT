extends CanvasLayer

onready var aLabel := $Attempts

func _process(delta):
	aLabel.rect_position.y = lerp(aLabel.rect_position.y, 241 if get_parent().editing else 215, 12 * delta)
