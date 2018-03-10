extends KinematicBody2D

# include
var bulletSceneFile = "res://Enemies/EnemyShot.tscn"
var bulletScene

export(int) var shootingTurnInterval = 1

# Movement
var lastPos
var targetPos
var direction = Vector2(-1, 0)
export(float) var moveSpeed = 1

# state
var killMe = false
export(int) var collisionDamage = 10
export(int) var health = 10
var shootTurnCounter = 0

var enemyManager

func _ready():
	bulletScene = load(bulletSceneFile)
	lastPos = global_position
	enemyManager = get_parent()

func startMove():
	lastPos = global_position
	targetPos = lastPos + direction * moveSpeed
	
	var shootTarget = getPlayerPos()
	if shootTarget:
		shootAt(shootTarget)
			
func endMove():
	pass

func hit(damageAmount):
	health -= damageAmount
	if health <= 0:
		killMe = true

func canBeDestroyed():
	return killMe

func move(moveProgressPercentage):
	if(!targetPos):
		return
	
	var nextPos = lastPos.linear_interpolate(targetPos, moveProgressPercentage)
	var collision = move_and_collide(nextPos - global_position)
	
	if collision:
		killMe = true
		if collision.collider.get_name() == "Player":
			collision.collider.hit(collisionDamage)

func shootAt(shootTarget):
	shootTurnCounter += 1
	if shootTurnCounter >= shootingTurnInterval:
		shootTurnCounter = 0
		var bullet = bulletScene.instance()
		enemyManager.add_child(bullet)
		enemyManager.enemyBullets.append(bullet)
		var bulletPos = global_position - Vector2(16, 0)
		bullet.global_position = bulletPos
		
		var shootDir = shootTarget - global_position
		bullet.setDirection(shootDir)
		
func getPlayerPos():
	var playerNode = get_node("/root/Game/Player")
	if playerNode:
		var playerPos = playerNode.global_position
		return playerPos
	
