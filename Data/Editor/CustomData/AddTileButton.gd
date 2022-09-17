extends TextureRect

func _ready():
	var _unused = connect("gui_input", self, "_itemClick")
	
func _itemClick(event):
	if event is InputEvent:
		if event is InputEventMouseButton:
			print("dbg")
