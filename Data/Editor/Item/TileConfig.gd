extends Control

onready var xValue := $Panel/Controls/Position/VBoxContainer/HboxContainer/VBoxContainer/XVal
onready var yValue := $Panel/Controls/Position/VBoxContainer/HboxContainer/VBoxContainer2/YVal

onready var flipH := $Panel/Controls/Flip/VBoxContainer/HboxContainer/FlipX
onready var flipV := $Panel/Controls/Flip/VBoxContainer/HboxContainer/FlipY
onready var transpose := $Panel/Controls/Flip/VBoxContainer/HboxContainer/Transpose

onready var exit := $ExitButton

var targetTile := Vector2()
var targetMap : TileMap
var dragPos = null

func _ready():
	var _unused = $Panel.connect("gui_input", self, "_onGuiInput")
	_unused = exit.connect("pressed", self, "_onExitPress")
	
	_unused = xValue.connect("text_entered", self, "_xChange")
	_unused = yValue.connect("text_entered", self, "_yChange")
	
	xValue.text = str(targetTile.x)
	yValue.text = str(targetTile.y)
	
# warning-ignore:narrowing_conversion
# warning-ignore:narrowing_conversion
	flipH.pressed = targetMap.is_cell_x_flipped(targetTile.x, targetTile.y)
# warning-ignore:narrowing_conversion
# warning-ignore:narrowing_conversion
	flipV.pressed = targetMap.is_cell_y_flipped(targetTile.x, targetTile.y)
# warning-ignore:narrowing_conversion
# warning-ignore:narrowing_conversion
	transpose.pressed = targetMap.is_cell_transposed(targetTile.x, targetTile.y)
	
func _xChange(new := "0"):
	var cellID = targetMap.get_cellv(targetTile)
	
	targetMap.set_cellv(targetTile, -1)
	targetTile.x = int(new)
	
	targetMap.set_cellv(targetTile, cellID)
	
func _yChange(new := "0"):
	var cellID = targetMap.get_cellv(targetTile)
	
	targetMap.set_cellv(targetTile, -1)
	targetTile.y = int(new)
	
	targetMap.set_cellv(targetTile, cellID)
	
func _process(_delta):
	targetMap.set_cellv(targetTile, targetMap.get_cellv(targetTile), flipH.pressed, flipV.pressed, transpose.pressed)

func _onExitPress():
	close()
	
func close():
	get_parent().get_parent().cursor.configurator = null
	get_parent().get_parent().cursor.canPlace = true
	
	queue_free()
	

func _onGuiInput(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				dragPos = get_global_mouse_position() - get_position()
			else:
				dragPos = null
		
	if event is InputEventMouseMotion && dragPos:
		set_position(get_global_mouse_position() - dragPos)
