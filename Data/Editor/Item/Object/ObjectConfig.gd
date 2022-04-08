extends Control

onready var xPos := $P/Ctl/T/Vbc/Hbc/Vbc/SXPos
onready var yPos := $P/Ctl/T/Vbc/Hbc/Vbc2/SYPos

onready var angle := $P/Ctl/T/Vbc/Hbc/Vbc3/A

onready var xScl := $P/Ctl/T/Vbc/Hbc2/Vbc/Hbc/Vbc/XScl
onready var yScl := $P/Ctl/T/Vbc/Hbc2/Vbc/Hbc/Vbc2/YScl

onready var exit := $Exit

var target : Node2D

onready var targetTile := (target.global_position / 16).round()

func _ready():
	_setupExitButton()
	_setupPosition()
	_setupRotation()
	_setupScale()
	
	if target.get("drawGizmos") != null:
		target.drawGizmos = true
	
func _setupExitButton():
	var _unused = exit.connect("pressed", self, "_onExitPress")
	
func _setupPosition():
	xPos.text = str(targetTile.x)
	yPos.text = str(targetTile.y)
	
	var _unused = xPos.connect("text_entered", self, "_xPosChange")
	_unused = yPos.connect("text_entered", self, "_yPosChange")
	
func _setupRotation():
	if target.get("_editorRotate"):
		angle.text = str(target.get("_editorRotate").rotation_degrees)
	else:
		angle.text = str(target.rotation_degrees)
		
	var _unused = angle.connect("text_entered", self, "_angleChange")
	
func _setupScale():
	xScl.text = str(target.scale.x)
	yScl.text = str(target.scale.y)
	
	var _unused = xScl.connect("text_entered", self, "_xSclChange")
	_unused = yScl.connect("text_entered", self, "_ySclChange")
	
func _xPosChange(new := "0"):
	target.global_position.x = int(new) * 16
	
	targetTile = (target.global_position / 16).round()
	
func _yPosChange(new := "0"):
	target.global_position.y = int(new) * 16
	
	targetTile = (target.global_position / 16).round()
	
func _angleChange(new := "0"):
	if target.get("_editorRotate"):
		target.get("_editorRotate").rotation_degrees = int(new)
		return
		
	target.rotation_degrees = int(new)
	
func _xSclChange(new := "0"):
	target.scale.x = int(new)
	
func _ySclChange(new := "0"):
	target.scale.y = int(new)
	
func _onExitPress():
	close()
	
func close():
	get_parent().get_parent().cursor.configurator = null
	get_parent().get_parent().cursor.canPlace = true
	
	if target.get("drawGizmos") != null:
		target.drawGizmos = false
		
	queue_free()

