extends TextureRect

export (bool) var isTile = true
export (String) var itemName
export (PackedScene) var itemScene
export (bool) var singleInstance = false
export (Dictionary) var customParams

onready var editor = get_tree().get_nodes_in_group("Editor")[0]

var cursor

var tileID := 0
var selected := false setget _gotSelected

func _gotSelected(booly):
	selected = booly
	
	$Border.visible = booly
	
func _ready():
	if isTile:
		texture = _tileTexGen()
		
	cursor = get_tree().get_nodes_in_group("Cursor")[0]
	
	var _unused = connect("gui_input", self, "_itemClick")
	
	if selected: cursor.target = self
	
func _tileTexGen():
	var tex = Main.level.tile_set.tile_get_texture(tileID)
	var region = Main.level.tile_set.tile_get_region(tileID)
	itemName = Main.level.tile_set.tile_get_name(tileID)
	
	var atlasTex := AtlasTexture.new()
	
	atlasTex.atlas = tex
	atlasTex.region = region
	
	return atlasTex
	
func _itemClick(event):
	if event is InputEvent:
		if event.is_action_pressed("mouse_main"):
			get_tree().get_nodes_in_group("Editor")[0].desc.msg(itemName)
	
			var containers = get_parent().get_parent().get_parent().get_parent().get_parent().containers
			
			for c in containers:
				for i in c.get_children():
					i.selected = false
				
			self.selected = true
			
			cursor.target = self
