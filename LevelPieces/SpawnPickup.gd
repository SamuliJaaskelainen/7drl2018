extends Position2D

export(int) var pickupId = 0
export(float) var spawnValue = 0.5
var pickupAssets = []
var pickupPower = preload("res://Pickups/PickupPower.tscn")
var pickupArmor = preload("res://Pickups/PickupArmor.tscn")
var pickupMoney = preload("res://Pickups/PickupMoney.tscn")
var inited = false

func _ready():
	pickupAssets.append(pickupPower)
	pickupAssets.append(pickupArmor)
	pickupAssets.append(pickupMoney)

func init():
	inited = true
	
	if rand_range(0.0, 1.0) < spawnValue:
		var pickup = pickupAssets[pickupId].instance()
		get_parent().add_child(pickup)
		pickup.global_position = global_position

	
func _process(delta):
	if not inited:
		init()
