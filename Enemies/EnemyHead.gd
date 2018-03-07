extends "res://Enemies/Enemy.gd"

var t = 0.0
var curve = Curve.new()

func _ready():
	._ready()
	curve.add_point(Vector2(0,-1))
	curve.add_point(Vector2(0.5,1))
	curve.add_point(Vector2(1,-1))
	curve.bake()

func startMove():
	lastPos = global_position
	targetPos = lastPos + direction * moveSpeed + Vector2(0,curve.interpolate(t) * 8)
	t += 0.5
	if t > 1:
		t -= 1
