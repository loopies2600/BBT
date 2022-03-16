extends Label

export (Vector2) var charSize = Vector2(8, 8)
export (Vector2) var charSpacing = Vector2(8, 8)
export (Texture) var texture
export (String) var path = "res://Sprites/Font/Main.tres"
export (Vector2) var tallCharOffset = Vector2()
export (PoolStringArray) var columns

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
			
			var offset : Vector2 = tallCharOffset if ord(columns[i][c]) in [103, 112, 113, 121] else Vector2()
			
			bm.add_char(unicode, 0, Rect2(charPos, Vector2(charSize.x, charSize.y)), offset, charSpacing.x)
			
			row += 1
			
		row = 0
		column += 1
		
	bm.height = charSpacing.y
	var _err = ResourceSaver.save(path, bm)
