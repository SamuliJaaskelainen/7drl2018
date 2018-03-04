extends "res://SingleShot.gd"

var offset = Vector2(0,-4)
var shot = false

func _ready():
	damage = 100

func startMove():
	$Sprite.scale.x = 0
	pass

func move(val):
	
	if val > 0.9 and not shot:
		shot = true
		$RayCast2D.force_raycast_update()
		var rayLenght = 512
		var playerPos = get_parent().find_node("Player").global_position
		$RayCast2D.global_position = playerPos + offset
		$Sprite.global_position = playerPos + offset
		if $RayCast2D.is_colliding():
			if ($RayCast2D.get_collider().get_name() == "Enemy"):
				$RayCast2D.get_collider().hit(damage)
			rayLenght = $RayCast2D.get_collision_point().x - playerPos.x
			print("Railing %s", $RayCast2D.get_collider().get_name())
		$Sprite.scale.x = rayLenght
	
func endMove():
	killMe = true
