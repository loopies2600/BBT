extends Control

onready var buttons := [$PC/CenterContainer/Vbc/TextHbc/LayerVbc/Foreground, $PC/CenterContainer/Vbc/TextHbc/LayerVbc/LevelLayout, $PC/CenterContainer/Vbc/TextHbc/LayerVbc/Background]
onready var bs := $PC/CenterContainer/Vbc/Hbc/BS
onready var cursor = get_tree().get_nodes_in_group("Cursor")[0]
onready var er := $PC/CenterContainer/Vbc/Hbc2/ER

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
	visible = idx == 0

func _onGMChange(idx : int):
	visible = idx == 1
