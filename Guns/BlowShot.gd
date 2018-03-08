extends "res://Guns/SingleShot.gd"

func _ready():
	damage = 10
	pass

func startMove():
	pass

func move(val):
	if(val > 0.33):
		killMe = true
		
func endMove():
	killMe = true
	pass

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	killMe = true
