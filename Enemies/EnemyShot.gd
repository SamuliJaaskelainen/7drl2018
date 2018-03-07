extends KinematicBody2D

var direction = Vector2(0,0)
var lastPos
var targetPos

export var collisionDamage = 10
export(float) var moveSpeed = 1
var killMe = false

func setDirection(value):
	direction = value.normalized()
	print(direction)

func startMove():
	lastPos = global_position
	targetPos = lastPos + direction * moveSpeed
	
func endMove():
	pass

func move(moveProgressPercentage):
	var nextPos = lastPos.linear_interpolate(targetPos, moveProgressPercentage)
	var collision = move_and_collide(nextPos - global_position)
	
	if collision:
		killMe = true
		if collision.collider.get_name() == "Player":
			collision.collider.hit(collisionDamage)
			
func _on_VisibilityNotifier2D_viewport_exited(viewport):
	killMe = true
	