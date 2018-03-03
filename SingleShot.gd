extends KinematicBody2D

var damage = 10
var dir = Vector2(1,0)
var speed = 120
var lastPos
var targetPos
var killMe = false

func startMove():
	lastPos = global_position
	targetPos = global_position + dir * speed

func move(var val):
	var nextPos = lastPos.linear_interpolate(targetPos, val)
	var collision = move_and_collide(nextPos - global_position)
	
	if collision:
		if (collision.collider.get_name() == "Player"):
			collision.collider.hit(damage)
		killMe = true

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	killMe = true
	

