extends TextureRect

export (PackedScene) var itemScene

var cursor : Sprite

var isTile := true
var tileID := 0

func _ready():
	connect("gui_input", self, "_itemClick")
	
func _itemClick(event):
	if event is InputEvent:
		if event.is_action_pressed("mouse_main"):
			cursor.isTile = isTile
			
			if isTile:
				cursor.tileID = tileID
			else:
				cursor.itemScene = itemScene
				
			cursor.texture = texture
