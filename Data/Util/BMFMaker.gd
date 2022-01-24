extends Node

export (int) var charSize = 8
export (Texture) var texture
export (PoolStringArray) var columns
export (String) var path = "res://Sprites/Font/Main.tres"

onready var bm := BitmapFont.new()

func _ready():
	generate()
	
func generate():
	var column := 0
	var row := 0
	
	var bitmapSize := Vector2(int(texture.get_size().x / charSize), int(texture.get_size().y / charSize))
	
	bm.add_texture(texture)
	
	for i in range(columns.size()):
		for c in range(columns[i].length()):
			var charPos := Vector2(charSize * row, charSize * column)
			print(charPos)
			var unicode = ord(columns[i][c])
			
			bm.add_char(unicode, 0, Rect2(charPos, Vector2(charSize, charSize)))
			
			row += 1
			
		row = 0
		column += 1
		
	ResourceSaver.save(path, bm)
