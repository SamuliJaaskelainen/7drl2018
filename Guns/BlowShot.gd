extends "res://Guns/SingleShot.gd"

func _ready():
	damage = 10
	pass

func startMove():
	pass

func move(val):
	var playerPos = get_parent().find_node("Player").global_position
	
		
func endMove():
	killMe = true
	pass

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	killMe = true
