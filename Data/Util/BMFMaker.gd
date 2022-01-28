extends Label

export (Vector2) var charSize = Vector2(8, 8)
export (int) var charSpacing = 8
export (Texture) var texture
export (PoolStringArray) var columns
export (String) var path = "res://Sprites/Font/Main.tres"

onready var bm := BitmapFont.new()

func _ready():
	generate()
	
func generate():
	bm.add_texture(texture)
	
	var column := 0
	var row := 0
	
	for i in range(columns.size()):
		for c in range(columns[i].length()):
			var charPos := Vector2(charSize.x * row, charSize.y * column)
			var unicode = ord(columns[i][c])
			bm.add_char(unicode, 0, Rect2(charPos, Vector2(charSize.x, charSize.y)), Vector2(), charSpacing)
			
			row += 1
			
		row = 0
		column += 1
		
	ResourceSaver.save(path, bm)
