extends "res://Enemies/Enemy.gd"



func startMove():
	lastPos = global_position
	var playerPos = getPlayerPos()
	if playerPos.x < lastPos.x:
		direction = (playerPos - lastPos).normalized()
	else:
		direction = Vector2(-1,0)
	targetPos = lastPos + direction * moveSpeed
	targetPos += Vector2(rand_range(-4,4), rand_range(-4,4))

