extends Node2D

const EMPTY := preload("res://Sprites/UI/SmallTokenEmpty.tres")
const FULL := preload("res://Sprites/UI/SmallToken.tres")

export (int) var separation = 10

var startPos := Vector2(402, 4)

func _process(_delta):
	update()
	
func _draw():
	if !is_instance_valid(Main.level): return
	
	for i in range(Main.level.tokenAmount):
		draw_texture(EMPTY, startPos - Vector2(separation * i, 0))
		
	for i in range(Main.level.tokensCollected):
		draw_texture(FULL, startPos - Vector2(separation * i, 0))
