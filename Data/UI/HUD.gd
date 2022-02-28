extends CanvasLayer

onready var fpsCount := $FrameRate
onready var aLabel := $Attempts

func _process(delta):
	fpsCount.rect_position.y = lerp(fpsCount.rect_position.y, -10 if get_parent().editing else 0, 12 * delta)
	aLabel.rect_position.y = lerp(aLabel.rect_position.y, 241 if get_parent().editing else 232, 12 * delta)
