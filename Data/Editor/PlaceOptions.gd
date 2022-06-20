extends Control

onready var buttons := [$PC/CenterContainer/Vbc/TextHbc/LayerVbc/Foreground, $PC/CenterContainer/Vbc/TextHbc/LayerVbc/LevelLayout, $PC/CenterContainer/Vbc/TextHbc/LayerVbc/Background]
onready var bs := $PC/CenterContainer/Vbc/Hbc/BS
onready var cursor = get_tree().get_nodes_in_group("Cursor")[0]

onready var bsW := $PC/CenterContainer/Vbc/Hbc
onready var ff := $PC/CenterContainer/Vbc/Hbc3/FF

func _ready():
	rect_size = Vector2(88, 128)
	
	buttons[1].selected = true
	
	bs.text = str(cursor.modes[0].brushSize)
	
	visible = cursor.mode == 0
	
	var _unused = cursor.connect("mode_changed", self, "_onModeChange")
	
	_unused = bs.connect("text_entered", self, "_bsChange")
	_unused = ff.connect("toggled", self, "_ffPress")
	
func _bsChange(new := "0"):
	cursor.modes[0].brushSize = int(new)
	
func _ffPress(togl := false):
	cursor.modes[0].floodFill = togl
	bsW.visible = !togl
	
func _onModeChange(idx : int):
	visible = idx != 1
	
	bsW.visible = idx == 0 && !ff.pressed
	ff.visible = idx == 0
	
	rect_size = Vector2(88, 128) if idx == 0 else Vector2(72, 72)
