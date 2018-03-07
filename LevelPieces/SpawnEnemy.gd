extends Position2D

export(int) var enemyId = 0
export(float) var spawnValue = 0.5
var enemyAssets = []
var enemy1 = preload("res://Enemies/Enemy.tscn")
var enemy2 = preload("res://Enemies/EnemyMine.tscn")
var enemy3 = preload("res://Enemies/EnemyHead.tscn")
var enemy4 = preload("res://Enemies/EnemyFish.tscn")
var inited = false


func _ready():
	enemyAssets.append(enemy1)
	enemyAssets.append(enemy2)
	enemyAssets.append(enemy3)
	enemyAssets.append(enemy4)
	
func init():
	inited = true
	
	if rand_range(0.0, 1.0) < spawnValue:
		var enemy = enemyAssets[enemyId].instance()
		var enemyManager = get_parent().get_parent().get_parent().get_node("EnemyManager")
		enemyManager.add_child(enemy)
		enemyManager.enemies.append(enemy)
		enemy.global_position = global_position
	
	
func _process(delta):
	if not inited and global_position.x <= 520:
		init()
