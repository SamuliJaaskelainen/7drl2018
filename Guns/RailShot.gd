extends "res://Guns/SingleShot.gd"

var shot = false

func startMove():
	$Sprite.scale.x = 0
	pass

func move(val):
	
	if val > 0.9 and not shot:
		var hitEnemies = []
		shot = true
		var rayLenght = 512
		var playerPos = get_parent().find_node("Player").global_position
		$RayCast2D.global_position = playerPos + Vector2(0, -4)
		$RayCast2DUp.global_position = playerPos + Vector2(0, 7)
		$RayCast2DDown.global_position = playerPos + Vector2(0,-1)
		$Sprite.global_position = playerPos + Vector2(0, -4)

		$RayCast2D.force_raycast_update()
		if $RayCast2D.is_colliding():
			if "Enemy" in $RayCast2D.get_collider().get_name():
				hitEnemies.append($RayCast2D.get_collider().get_name())
				$RayCast2D.get_collider().hit(damage)
				print("Railing0 %s", $RayCast2D.get_collider().get_name())
			rayLenght = $RayCast2D.get_collision_point().x - playerPos.x
				
		$RayCast2DUp.cast_to = Vector2(rayLenght, 0)
		$RayCast2DUp.force_raycast_update()
		if $RayCast2DUp.is_colliding():
			if "Enemy" in $RayCast2DUp.get_collider().get_name() and not hitEnemies.has($RayCast2DUp.get_collider().get_name()):
				hitEnemies.append($RayCast2DUp.get_collider().get_name())
				$RayCast2DUp.get_collider().hit(damage)
				print("Railing1 %s", $RayCast2D.get_collider().get_name())
				
		$RayCast2DDown.cast_to = Vector2(rayLenght, 0)
		$RayCast2DDown.force_raycast_update()
		if $RayCast2DDown.is_colliding():
			if "Enemy" in $RayCast2DDown.get_collider().get_name() and not hitEnemies.has($RayCast2DDown.get_collider().get_name()):
				hitEnemies.append($RayCast2DDown.get_collider().get_name())
				$RayCast2DDown.get_collider().hit(damage)
				print("Railing2 %s", $RayCast2D.get_collider().get_name())
		
		$Sprite.scale.x = rayLenght
	
func endMove():
	killMe = true
