extends Control

onready var xPos := $Panel/Controls/Transform/VBoxContainer/HboxContainer/VBoxContainer/XVal
onready var yPos := $Panel/Controls/Transform/VBoxContainer/HboxContainer/VBoxContainer2/YVal
onready var angle := $Panel/Controls/Transform/VBoxContainer/HboxContainer/VBoxContainer3/Angle
onready var xScl := $Panel/Controls/Transform/VBoxContainer/HboxContainer3/VBoxContainer/HboxContainer/VBoxContainer3/XScl
onready var yScl := $Panel/Controls/Transform/VBoxContainer/HboxContainer3/VBoxContainer/HboxContainer/VBoxContainer4/YScl

onready var exit := $ExitButton

var target : Node2D

onready var targetTile := (target.global_position / 16).round()

func _ready():
	var _unused = exit.connect("pressed", self, "_onExitPress")
	
	xPos.text = str(targetTile.x)
	yPos.text = str(targetTile.y)
	
	if target.get("_editorRotate"):
		angle.text = str(target.get("_editorRotate").rotation_degrees)
	else:
		angle.text = str(target.rotation_degrees)
		
	xScl.text = str(target.scale.x)
	yScl.text = str(target.scale.y)
	
	_unused = xPos.connect("text_entered", self, "_xPosChange")
	_unused = yPos.connect("text_entered", self, "_yPosChange")
	_unused = angle.connect("text_entered", self, "_angleChange")
	_unused = xScl.connect("text_entered", self, "_xSclChange")
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
	get_parent().get_parent().cursor.configurator = null
	get_parent().get_parent().cursor.canPlace = true
	
	queue_free()

