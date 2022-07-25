extends TextureRect

onready var border := $Border
onready var cursor = get_tree().get_nodes_in_group("Cursor")[0]
onready var btOwner = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()

export (bool) var selected := false setget _gotSelected

func _gotSelected(booly):
	selected = booly
	
	$Border.visible = booly
	
func _ready():
	yield(btOwner, "ready")
	
	if name == "LevelLayout": enable()
	
	var _unused = connect("gui_input", self, "_itemClick")
	
func _itemClick(event):
	if event is InputEvent:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT && event.is_pressed():
				enable()
				
				match name:
					"Foreground":
						cursor.targetTilemap = Main.level.get_node("Foreground")
					"LevelLayout":
						cursor.targetTilemap = Main.level
					"Background":
						cursor.targetTilemap = Main.level.get_node("Background")

func enable():
	for i in btOwner.buttons:
		i.selected = false
		
	self.selected = true
