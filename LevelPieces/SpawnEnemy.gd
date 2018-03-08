extends Position2D

export(int) var enemyId = 0
export(float) var spawnValue = 0.5
var enemyAssets = []
var enemy1 = preload("res://Enemies/Enemy.tscn")
var enemy2 = preload("res://Enemies/EnemyMine.tscn")
var enemy3 = preload("res://Enemies/EnemyHead.tscn")
var enemy4 = preload("res://Enemies/EnemyFish.tscn")
var timer

#func _ready():
func _notification(what):
	if what == NOTIFICATION_PARENTED:
		enemyAssets.append(enemy1)
		enemyAssets.append(enemy2)
		enemyAssets.append(enemy3)
		enemyAssets.append(enemy4)
		timer = Timer.new() 
		timer.connect("timeout",self,"_tryInit") 
		timer.wait_time = 0.1
		add_child(timer)
		timer.start()
	
func init():
	timer.stop()
	
	if rand_range(0.0, 1.0) < spawnValue:
		var enemy = enemyAssets[enemyId].instance()
		var enemyManager = $"/root/Game/EnemyManager"
		enemyManager.add_child(enemy)
		enemyManager.enemies.append(enemy)
		enemy.global_position = global_position
		
	queue_free()
	
func _tryInit():
	if global_position.x < 544:
		init()
