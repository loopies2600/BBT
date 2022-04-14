extends Node2D

export (float) var ___tempRot = 0.0

onready var _editorRotate = $Sprite

func _ready():
	_editorRotate.rotation = ___tempRot
	
