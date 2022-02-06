extends Control

onready var xValue := $Panel/Controls/Position/VBoxContainer/HboxContainer/VBoxContainer/XVal
onready var yValue := $Panel/Controls/Position/VBoxContainer/HboxContainer/VBoxContainer2/YVal

onready var flipH := $Panel/Controls/Flip/VBoxContainer/HboxContainer/FlipX
onready var flipV := $Panel/Controls/Flip/VBoxContainer/HboxContainer/FlipY
onready var transpose := $Panel/Controls/Flip/VBoxContainer/HboxContainer/Transpose

onready var exit := $ExitButton

var targetTile := Vector2()

func _ready():
	var _unused = exit.connect("pressed", self, "_onExitPress")
	
	_unused = xValue.connect("text_entered", self, "_xChange")
	_unused = yValue.connect("text_entered", self, "_yChange")
	
	xValue.text = str(targetTile.x)
	yValue.text = str(targetTile.y)
	
	flipH.pressed = Global.level.is_cell_x_flipped(targetTile.x, targetTile.y)
	flipV.pressed = Global.level.is_cell_y_flipped(targetTile.x, targetTile.y)
	transpose.pressed = Global.level.is_cell_transposed(targetTile.x, targetTile.y)
	
func _xChange(new := "0"):
	var cellID = Global.level.get_cellv(targetTile)
	
	Global.level.set_cellv(targetTile, -1)
	targetTile.x = int(new)
	
	Global.level.set_cellv(targetTile, cellID)
	
func _yChange(new := "0"):
	var cellID = Global.level.get_cellv(targetTile)
	
	Global.level.set_cellv(targetTile, -1)
	targetTile.y = int(new)
	
	Global.level.set_cellv(targetTile, cellID)
	
func _process(_delta):
	Global.level.set_cellv(targetTile, Global.level.get_cellv(targetTile), flipH.pressed, flipV.pressed, transpose.pressed)

func _onExitPress():
	get_parent().get_parent().get_parent().cursor.configurator = null
	queue_free()
