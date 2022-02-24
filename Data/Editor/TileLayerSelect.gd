extends Control

onready var buttons := [$PC/CenterContainer/TextHbc/LayerVbc/Foreground, $PC/CenterContainer/TextHbc/LayerVbc/Base, $PC/CenterContainer/TextHbc/LayerVbc/Background]

func _process(_delta):
	visible = get_tree().get_nodes_in_group("Cursor")[0].mode == 0 && Main.editing
