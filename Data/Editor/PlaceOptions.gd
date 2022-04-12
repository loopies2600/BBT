extends Control

onready var buttons := [$PC/CenterContainer/Vbc/TextHbc/LayerVbc/Foreground, $PC/CenterContainer/Vbc/TextHbc/LayerVbc/LevelLayout, $PC/CenterContainer/Vbc/TextHbc/LayerVbc/Background]
onready var bs := $PC/CenterContainer/Vbc/Hbc/BS
onready var cursor = get_tree().get_nodes_in_group("Cursor")[0]
onready var er := $PC/CenterContainer/Vbc/Hbc2/ER

onready var bsW := $PC/CenterContainer/Vbc/Hbc
onready var erW := $PC/CenterContainer/Vbc/Hbc2

func _ready():
	buttons[1].selected = true
	
	bs.text = str(cursor.modes[0].brushSize)
	er.text = str(cursor.modes[0].explosionRadius)
	
	visible = cursor.mode == 0
	
	var _unused = cursor.connect("mode_changed", self, "_onModeChange")
	_unused = Main.connect("game_mode_changed", self, "_onGMChange")
	
	_unused = bs.connect("text_entered", self, "_bsChange")
	_unused = er.connect("text_entered", self, "_erChange")
	
func _bsChange(new := "0"):
	cursor.modes[0].brushSize = int(new)
	
func _erChange(new := "0"):
	cursor.modes[0].explosionRadius = int(new)
	
func _onModeChange(idx : int):
	visible = idx != 1
	
	bsW.visible = idx == 0
	erW.visible = idx == 0
	
	rect_size = Vector2(88, 136) if idx == 0 else Vector2(72, 72)
	rect_position = Vector2(296, 24) if idx == 0 else Vector2(312, 24)
	
func _onGMChange(idx : int):
	visible = idx == 1
