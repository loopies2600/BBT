extends Node2D

const EMPTY := preload("res://Sprites/UI/SmallTokenEmpty.tres")
const FULL := preload("res://Sprites/UI/SmallToken.tres")

export (int) var separation = 10

func _process(_delta):
	update()
	
func _draw():
	for i in range(Main.level.tokenAmount):
		draw_texture(EMPTY, Vector2() - Vector2(separation * i, 0))
		
	for i in range(Main.level.tokensCollected):
		draw_texture(FULL, Vector2() - Vector2(separation * i, 0))
