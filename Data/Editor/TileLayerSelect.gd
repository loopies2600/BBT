extends Control

onready var buttons := [$PC/CenterContainer/TextHbc/LayerVbc/Foreground, $PC/CenterContainer/TextHbc/LayerVbc/Base, $PC/CenterContainer/TextHbc/LayerVbc/Background]

func _ready():
	buttons[1].selected = true
	
	var cursor = get_tree().get_nodes_in_group("Cursor")[0]
	visible = cursor.mode == 0
	
	var _unused = cursor.connect("mode_changed", self, "_onModeChange")
	
func _onModeChange(idx : int):
	visible = idx == 0
