extends "res://Guns/SingleShot.gd"

var v = 0

func startMove():
	lastPos = global_position
	v += 0.25
	dir.x = lerp(dir.x, 0.0, v)
	targetPos = global_position + dir * speed
