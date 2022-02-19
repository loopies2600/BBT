extends TabContainer

onready var containers := [$Tiles/ScrollContainer/VBoxContainer/HBoxContainer, $Objects/ScrollContainer/VBoxContainer/HBoxContainer, $Entities/ScrollContainer/VBoxContainer/HBoxContainer, $Markers/ScrollContainer/VBoxContainer/HBoxContainer]

func _ready():
	var _unused = connect("tab_changed", self, "_tabChange")
	
func _tabChange(_tab):
	_deselectAll()
	
func _deselectAll():
	var oneSelected = false
	
	for c in containers:
		for i in c.get_children():
			if oneSelected:
				i.selected = false
				
			if i.selected: oneSelected = true
