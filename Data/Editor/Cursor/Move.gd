extends "res://Data/Editor/Cursor/CursorMode.gd"

var holding = null
var rotating := false

func update():
	rotating = Input.is_action_pressed("mouse_secondary")
	
	get_parent().texture = null
	get_parent().configuratorCheck()
	
func mainClick(event):
	if !get_parent().canPlace: return
	
	if event.is_action_pressed("mouse_main"):
		holding = Main.getNodeOnThisPos(get_parent().cellPos)
	if event.is_action_released("mouse_main"):
		holding = null
	
	if event is InputEventMouseMotion:
		if !holding: return
		
		if rotating:
			var amt : float = event.relative.y * 0.025
			
			if holding.get("_editorRotate"):
				holding.get("_editorRotate").rotation += amt
			else:
				holding.rotation += amt
		else:
			holding.global_position = (event.position - Vector2(8, 8) - get_parent().get_canvas_transform().origin) * Main.cam.zoom
			holding.global_position = (holding.global_position / get_parent().level.cell_size).round() * get_parent().level.cell_size
