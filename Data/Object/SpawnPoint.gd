tool
extends Position2D

const SPICON := preload("res://Sprites/Object/Editor/SpawnPoint.png")

var y := 0.0
var _time := 0.0

func _process(delta):
	if !Engine.editor_hint: return
	
	_time += delta
	
	y = sin(_time * 2) * 4
	
	update()
	
func _draw():
	if Engine.editor_hint:
		draw_texture(SPICON, -SPICON.get_size() / 2 + Vector2(0, y))
