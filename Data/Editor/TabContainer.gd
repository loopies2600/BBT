extends TabContainer

onready var containers := [$Tiles/ScrollContainer/VBoxContainer/HBoxContainer, $Objects/ScrollContainer/VBoxContainer/HBoxContainer, $Entities/ScrollContainer/VBoxContainer/HBoxContainer, $Markers/ScrollContainer/VBoxContainer/HBoxContainer]

func _ready():
	var _unused = connect("mouse_entered", self, "_mouseIn")
	_unused = connect("mouse_exited", self, "_mouseOut")
	_unused = connect("tab_changed", self, "_tabChange")
	
func _mouseIn():
	Global.cursor.pointer = 1
	get_tree().get_nodes_in_group("Cursor")[0].canPlace = false
	
func _mouseOut():
	Global.cursor.pointer = 0
	get_tree().get_nodes_in_group("Cursor")[0].canPlace = true
	
func _tabChange(_tab):
	_deselectAll()
	
func _deselectAll():
	var oneSelected = false
	
	for c in containers:
		for i in c.get_children():
			if oneSelected:
				i.selected = false
				
			if i.selected: oneSelected = true
