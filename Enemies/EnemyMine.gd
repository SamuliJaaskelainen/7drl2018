extends "res://Enemies/Enemy.gd"


func startMove():
	lastPos = global_position
	targetPos = lastPos + direction * moveSpeed
			

func canBeDestroyed():
	return killMe

