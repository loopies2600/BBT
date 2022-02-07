extends Position2D

const SPICON := preload("res://Sprites/Object/Editor/SpawnPoint.png")

var y := 0.0
var _time := 0.0

func _process(delta):
	update()
	
	if !Global.editing: return
	
	_time += delta
	
	y = sin(_time * 2) * 4
	
func _draw():
	if Global.editing:
		draw_texture(SPICON, Vector2(-16, y))
