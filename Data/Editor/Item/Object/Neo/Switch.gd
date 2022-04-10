extends CheckButton

var tgVar := ""
var target

func _pressed():
	target.set_indexed(tgVar, !target.get_indexed(tgVar))
	
	owner.updateConfigurator()
