extends Position2D

export(int) var pickupId = 0
var enemyAssets = []
var enemy1 = preload("res://Enemy.tscn")
var inited = false

func _ready():
	enemyAssets.append(enemy1)
	
func init():
	var enemy = enemyAssets[pickupId].instance()
	var enemyManager = get_parent().get_parent().get_parent().get_node("EnemyManager")
	enemyManager.add_child(enemy)
	enemyManager.enemies.append(enemy)
	enemy.global_position = global_position
	inited = true
	
func _process(delta):
	if not inited:
		init()
