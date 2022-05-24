extends Node2D

const FONT := preload("res://Sprites/Font/Main.tres")
const CLOCK := preload("res://Sprites/UI/TimerClock.png")
const EMPTY := preload("res://Sprites/UI/SmallTokenEmpty.tres")
const FULL := preload("res://Sprites/UI/SmallToken.tres")

export (int) var separation = 10

var startPos := Vector2(412, 4)
var render := false

func _process(_delta):
	update()
	
func _draw():
	if !is_instance_valid(Main.currentScene): return
	if !is_instance_valid(Main.level): return
	
	if !render: return
	
	for i in range(Main.level.tokenAmount):
		draw_texture(EMPTY, startPos - Vector2(separation * i, 0))
		
	for i in range(Main.level.tokensCollected):
		draw_texture(FULL, startPos - Vector2(separation * i, 0))
	
	draw_texture(CLOCK, Vector2(4, 226))
	draw_string(FONT, Vector2(20, 226), Tools.formatTime(get_parent().lvlTime))
