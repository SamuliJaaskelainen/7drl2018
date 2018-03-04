extends Position2D

var pickupAsset = preload("res://PickupPower.tscn")
var inited = false

func init():
	var pickup = pickupAsset.instance()
	get_parent().add_child(pickup)
	pickup.global_position = global_position
	#call_deferred("add_child", pickup)
	inited = true
	print(get_parent().get_name())
	print(global_position)
	
func _process(delta):
	if not inited:
		init()
