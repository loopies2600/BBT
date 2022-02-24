extends TextureRect

onready var border := $Border

export (bool) var selected := false

func _ready():
	var _unused = connect("gui_input", self, "_itemClick")
	
func _process(_delta):
	border.visible = selected
	
func _itemClick(event):
	if event is InputEvent:
		if event.is_action_pressed("mouse_main"):
			for i in get_parent().get_parent().get_parent().get_parent().get_parent().buttons:
				i.selected = false
				
			selected = true
			
			match name:
				"Foreground":
					get_tree().get_nodes_in_group("Cursor")[0].targetTilemap = Main.level.get_node("Foreground")
				"Base":
					get_tree().get_nodes_in_group("Cursor")[0].targetTilemap = Main.level
				"Background":
					get_tree().get_nodes_in_group("Cursor")[0].targetTilemap = Main.level.get_node("Background")
