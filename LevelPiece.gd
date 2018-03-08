extends KinematicBody2D

var dir = Vector2(-1,0)
var pieceWidth = 256
var speed = 30
var lastPos
var targetPos
var killMe = false

func startMove():
	lastPos = global_position
	targetPos = global_position + dir * speed

func move(val):
	global_position = lastPos.linear_interpolate(targetPos, val)
	
	if global_position.x < -pieceWidth:
		killMe = true
