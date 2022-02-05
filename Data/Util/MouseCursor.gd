extends Node2D

enum Pointers {STANDARD, LINK, BUSY, MOVE}

const CURSOR_ATLAS := preload("res://Sprites/UI/MouseCursor.png")

var pointer = Pointers.STANDARD

func _init():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func _process(_delta):
	global_position = get_global_mouse_position()
	
	update()
	
func _draw():
	draw_texture_rect_region(CURSOR_ATLAS, Rect2(0, 0, 16, 16), Rect2(16 * pointer, 0, 16, 16))
