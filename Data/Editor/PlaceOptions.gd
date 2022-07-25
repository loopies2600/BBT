extends Control

onready var buttons := [$PC/CenterContainer/Vbc/TextHbc/LayerVbc/Foreground, $PC/CenterContainer/Vbc/TextHbc/LayerVbc/LevelLayout, $PC/CenterContainer/Vbc/TextHbc/LayerVbc/Background]
onready var bs := $PC/CenterContainer/Vbc/Hbc/BS
onready var cursor = get_tree().get_nodes_in_group("Cursor")[0]

onready var bsW := $PC/CenterContainer/Vbc/Hbc/BSL
onready var ff := $PC/CenterContainer/Vbc/Hbc/FF
onready var fx := $PC/CenterContainer/Vbc/HBoxContainer2/HboxContainer/FlipX
onready var fy := $PC/CenterContainer/Vbc/HBoxContainer2/HboxContainer/FlipY
onready var t := $PC/CenterContainer/Vbc/VBoxContainer/Transpose
onready var flipLab := $PC/CenterContainer/Vbc/HBoxContainer2/Flip

func _ready():
	buttons[1].selected = true
	
	bs.text = str(cursor.modes[0].brushSize)
	
	visible = cursor.mode == 0
	
	var _unused = cursor.connect("mode_changed", self, "_onModeChange")
	
	_unused = bs.connect("text_entered", self, "_bsChange")
	_unused = ff.connect("toggled", self, "_ffPress")
	_unused = fx.connect("pressed", self, "_fxPress")
	_unused = fy.connect("pressed", self, "_fyPress")
	_unused = t.connect("pressed", self, "_tPress")
	
func _bsChange(new := "0"):
	cursor.modes[0].brushSize = int(new)
	
func _ffPress(togl := false):
	cursor.modes[0].floodFill = togl
	bsW.visible = !togl
	bs.visible = !togl
	
func _fxPress():
	cursor.modes[0].basePlaceOptions.flip_x = fx.pressed
	
func _fyPress():
	cursor.modes[0].basePlaceOptions.flip_y = fy.pressed
	
func _tPress():
	cursor.modes[0].basePlaceOptions.transpose = t.pressed
	
func _onModeChange(idx : int):
	visible = idx != 1
	
	bs.visible = idx == 0 && !ff.pressed
	bsW.visible = idx == 0 && !ff.pressed
	ff.visible = idx == 0
	
	flipLab.visible = idx == 0
	fx.visible = idx == 0
	fy.visible = idx == 0
	t.visible = idx == 0
	
	rect_size = Vector2(144, 120) if idx == 0 else Vector2(144, 24) 
