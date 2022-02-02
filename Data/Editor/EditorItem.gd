extends TextureRect

export (bool) var isTile = true
export (String) var itemName
export (PackedScene) var itemScene
export (bool) var singleInstance = false
export (Dictionary) var customParams

onready var border := $Border
onready var editor = get_tree().get_nodes_in_group("Editor")[0]

var cursor : Sprite

var tileID := 0
var selected := false

func _ready():
	cursor = get_tree().get_nodes_in_group("Cursor")[0]
	
	var _unused = connect("gui_input", self, "_itemClick")
	
	if selected: cursor.target = self
	
func _process(_delta):
	border.visible = selected
	
func _itemClick(event):
	if event is InputEvent:
		if event.is_action_pressed("mouse_main"):
			var containers = get_parent().get_parent().get_parent().get_parent().get_parent().containers
			
			for c in containers:
				for i in c.get_children():
					i.selected = false
				
			selected = true
			
			cursor.target = self
