extends TextureRect

export (bool) var isTile = true
export (String) var itemName
export (PackedScene) var itemScene

onready var border := $Border
onready var editor = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()

var cursor : Sprite

var tileID := 0

var selected := false

func _ready():
	cursor = get_tree().get_nodes_in_group("Cursor")[0]
	
	var _unused = connect("gui_input", self, "_itemClick")
	
	if selected: cursor.texture = texture
	
func _process(_delta):
	border.visible = selected
	
func _itemClick(event):
	if event is InputEvent:
		if event.is_action_pressed("mouse_main"):
			for i in editor.tilesTab.get_children():
				i.selected = false
				
			selected = true
			cursor.isTile = isTile
			
			if isTile:
				cursor.tileID = tileID
			else:
				cursor.itemName = itemName
				cursor.itemScene = itemScene
			
			cursor.texture = texture
