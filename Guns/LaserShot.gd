extends "res://Guns/SingleShot.gd"

var offset = Vector2(0,-4)
var lastDelta

func startMove():
	lastDelta = 0

func _process(delta):
	lastDelta = delta

func move(val):
	$RayCast2D.force_raycast_update()
	var rayLenght = 512
	var playerPos = get_parent().find_node("Player").global_position
	$RayCast2D.global_position = playerPos + offset
	$Sprite.global_position = playerPos + offset
	if $RayCast2D.is_colliding():
		if "Enemy" in $RayCast2D.get_collider().get_name():
			$RayCast2D.get_collider().hit(damage * lastDelta)
		rayLenght = $RayCast2D.get_collision_point().x - playerPos.x
		print("Lasering %s", $RayCast2D.get_collider().get_name())
		
	$Sprite.scale.x = rayLenght
		
func endMove():
	killMe = true

