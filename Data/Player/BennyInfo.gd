extends Node2D

const FONT := preload("res://Sprites/Font/Main.tres")
const INPUTTEX := preload("res://Sprites/UI/DebugInputs.png")

const ACTIONNAMES := ["jump", "attack", "look_up", "look_down", "left", "right"]

var render := true
var motionPoints : PoolVector2Array = []

func _ready():
	update()
	
	_mpUpd()
	
func _process(_delta):
	update()
	
func _mpUpd():
	var pos : Vector2 = owner.global_position
	
	motionPoints.append(pos)
	
	yield(get_tree().create_timer(0.05), "timeout")
	_mpUpd()
	
func _input(event):
	if event is InputEventKey && !event.is_echo() && event.is_pressed():
		if event.scancode == KEY_B:
			render = !render
	
func _draw():
	if !render: return
	
	draw_rect(Rect2(0, 0, 192, 106), Color(0, 0, 0, 0.5))
	
	for i in range(ACTIONNAMES.size()):
		var on := Input.is_action_pressed(ACTIONNAMES[i])
	
		draw_texture_rect_region(INPUTTEX, Rect2(4 + (2 * i) + (16 * i), 64, 16, 16), Rect2(16 * i, 16 * int(on), 16, 16))
	
	draw_string(FONT, Vector2(4, 4), "BENNY INFO", Color.pink)
	draw_string(FONT, Vector2(4, 16), "STATE:%s" % owner.fsm.current_state.name.to_upper())
	draw_string(FONT, Vector2(4, 28), "POS: %s / %s" % [int(owner.global_position.x), int(owner.global_position.y)])
	draw_string(FONT, Vector2(4, 40), "SPD: %s / %s" % [int(owner.velocity.x), int(owner.velocity.y)])
	draw_string(FONT, Vector2(4, 52), "INPUTS:")
	draw_string(FONT, Vector2(4, 82), "CAN DASH:%s" % str(owner.canDash).to_upper())
	draw_string(FONT, Vector2(4, 94), "CAN WALLJUMP:%s" % str(owner.canWallJump).to_upper())
	
	draw_set_transform(owner.get_canvas_transform().origin, 0.0, Vector2.ONE)
	
	draw_polyline(motionPoints, Color.red, 2)
