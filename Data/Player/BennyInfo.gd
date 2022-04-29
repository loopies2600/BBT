extends Node2D

const FONT := preload("res://Sprites/Font/Main.tres")
const INPUTTEX := preload("res://Sprites/UI/DebugInputs.png")

const ACTIONNAMES := ["jump", "attack", "look_up", "look_down", "left", "right"]

var render := true

func _ready():
	update()
	
func _process(_delta):
	update()
	
func _input(event):
	if event is InputEventKey && !event.is_echo() && event.is_pressed():
		if event.scancode == KEY_B:
			render = !render
	
func _draw():
	if !render: return
	
	draw_rect(Rect2(0, 0, 192, 106), Color(0, 0, 0, 0.5))
	
	for i in range(4):
		var c = rand_range(0, 1)
		draw_rect(Rect2(0, 15 * int(rand_range(0, 7)), 192, 15), Color(c, c, c, 0.2))
	
	draw_string(FONT, Vector2(4, 4), "BENNY INFO")
	draw_string(FONT, Vector2(4, 16), "STATE:")
	draw_string(FONT, Vector2(70, 16), owner.fsm.current_state.name.to_upper(), Color.pink)
	draw_string(FONT, Vector2(4, 28), "H SPEED:%s" % int(owner.velocity.x))
	draw_string(FONT, Vector2(4, 40), "V SPEED:%s" % int(owner.velocity.y))
	draw_string(FONT, Vector2(4, 52), "INPUTS:")
	draw_string(FONT, Vector2(4, 82), "CAN DASH:%s" % str(owner.canDash).to_upper())
	draw_string(FONT, Vector2(4, 94), "CAN WALLJUMP:%s" % str(owner.canWallJump).to_upper())
	
	for i in range(ACTIONNAMES.size()):
		var on := Input.is_action_pressed(ACTIONNAMES[i])
		
		draw_texture_rect_region(INPUTTEX, Rect2(4 + (2 * i) + (16 * i), 64, 16, 16), Rect2(16 * i, 16 * int(on), 16, 16))
	
