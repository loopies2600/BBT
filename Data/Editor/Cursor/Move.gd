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
		holding = Main.getNodeOnThisPos(get_parent().cellPos * Main.cellSize)
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
				
			get_parent().modes[0].basePlaceOptions.rotation_degrees += amt
		else:
			holding.global_position = (event.position - Vector2(8, 8) - get_parent().get_canvas_transform().origin) * Main.cam.zoom
			holding.global_position = (holding.global_position / Main.cellSize).round() * Main.cellSize

			if holding.get("spawnPos"):
				holding.set("spawnPos", holding.global_position)
				
			if holding.get("_editorRotate"):
				holding.set("___tempRot", holding._editorRotate.rotation)
	
