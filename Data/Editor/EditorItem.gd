extends TextureRect

export (PackedScene) var itemScene

onready var border := $Border
onready var editor = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()

var cursor : Sprite

var isTile := true
var tileID := 0

var selected := false

func _ready():
	selected = tileID == 0
	
	var _unused = connect("gui_input", self, "_itemClick")
	
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
				cursor.itemScene = itemScene
				
			cursor.texture = texture
