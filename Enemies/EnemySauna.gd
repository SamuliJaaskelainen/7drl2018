extends "res://Enemies/Enemy.gd"

var upOffset = -30

func _ready():
	._ready()
	bulletSceneFile = "res://Enemies/EnemyFireShot.tscn"
	bulletScene = load(bulletSceneFile)

func startMove():
	lastPos = global_position
	targetPos = lastPos + direction * moveSpeed
	
	upOffset += 30
	
	if upOffset >= 60:
		upOffset = -30
	
	var shootTarget = Vector2(-100, lastPos.y + upOffset)
	if shootTarget:
		shootAt(shootTarget)
