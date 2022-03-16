extends MenuButton

onready var editor := owner.owner
onready var popup := get_popup()

func _ready():
	var _unused = connect("mouse_entered", self, "_mouseIn")
	_unused = connect("mouse_exited", self, "_mouseOut")
	
	_unused = popup.connect("mouse_entered", self, "_mouseIn")
	_unused = popup.connect("mouse_exited", self, "_mouseOut")
	
	_unused = popup.connect("id_pressed", self, "_popupButtonPress")
	
func _mouseIn():
	editor.cursor.canPlace = false
	
func _mouseOut():
	editor.cursor.canPlace = true
	
func _popupButtonPress(_id := 0):
	editor.cursor.canPlace = true
