extends Position2D

export(int) var enemyId = 0
export(float) var spawnValue = 0.5
var enemyAssets = []
var enemy1 = preload("res://Enemy.tscn")
var inited = false


func _ready():
	enemyAssets.append(enemy1)
	
func init():
	inited = true
	
	if rand_range(0.0, 1.0) < spawnValue:
		var enemy = enemyAssets[enemyId].instance()
		var enemyManager = get_parent().get_parent().get_parent().get_node("EnemyManager")
		enemyManager.add_child(enemy)
		enemyManager.enemies.append(enemy)
		enemy.global_position = global_position
	
	
func _process(delta):
	if not inited:
		init()
