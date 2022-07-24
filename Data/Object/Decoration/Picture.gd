extends Sprite

var webTools

func _ready():
	if OS.get_name() == "HTML5":
		webTools = Node.new()
		webTools.set_script(WebFiles.get_script())
		
		add_child(webTools)
		webTools.connect("file_opened", self, "_onWebFileOpen")
	
func clickEvent():
	match OS.get_name():
		"X11":
			var out := []
			var _unused = OS.execute("/usr/bin/zenity", ["--file-selection", "--file-filter=Images (*.png) | *png", "--title=Load Level"], true, out)
			
			if out[0]:
				var path : String = out[0]
				path.erase(out[0].length() - 1, 1)
				
				_setTex(path)
		"HTML5":
			webTools.open_file(".png")

func _onWebFileOpen(_file, content):
	var img = Image.new()
	var error = img.load_png_from_buffer(content)
	
	if error != OK: return
	
	img.compress(Image.COMPRESS_S3TC, Image.COMPRESS_SOURCE_GENERIC, 1.0)
	
	var tex = ImageTexture.new()
	tex.create_from_image(img, 2)
	
	texture = tex
	
func _setTex(path):
	var img = Image.new()
	var error = img.load(path)
	
	if error != OK: return
	
	img.compress(Image.COMPRESS_S3TC, Image.COMPRESS_SOURCE_GENERIC, 1.0)
	
	var tex = ImageTexture.new()
	tex.create_from_image(img, 2)
	
	texture = tex
