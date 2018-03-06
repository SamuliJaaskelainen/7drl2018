extends Position2D

export(int) var pickupId = 0
var pickupAssets = []
var pickupPower = preload("res://PickupPower.tscn")
var pickupArmor = preload("res://PickupArmor.tscn")
var pickupMoney = preload("res://PickupMoney.tscn")
var inited = false

func _ready():
	pickupAssets.append(pickupPower)
	pickupAssets.append(pickupArmor)
	pickupAssets.append(pickupMoney)

func init():
	var pickup = pickupAssets[pickupId].instance()
	get_parent().add_child(pickup)
	pickup.global_position = global_position
	inited = true
	
func _process(delta):
	if not inited:
		init()
