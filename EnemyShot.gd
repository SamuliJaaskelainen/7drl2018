extends KinematicBody2D

var direction = Vector2(0,0) setget setDirection
var lastPos
var targetPos

export var collisionDamage = 10
export(float) var moveSpeed = 1
var killMe = false

var playerName = "Player" setget setPlayerName

func setPlayerName(value):
	if find_node("root/" + value):
		playerName = value

func setDirection(value):
	if value.length() > 0:
		direction = value.normalized()

func canBeDestroyed():
	return killMe

func startMove():
	lastPos = global_position
	targetPos = lastPos + direction * moveSpeed

func move(moveProgressPercentage):
	var nextPos = lastPos.linear_interpolate(targetPos, moveProgressPercentage)
	var collision = move_and_collide(nextPos - lastPos)
	
	if collision:
		killMe = true
		if collision.collider.get_name() == playerName:
			collision.collider.hit(collisionDamage)
			
func _on_VisibilityNotifier2D_viewport_exited(viewport):
	killMe = true