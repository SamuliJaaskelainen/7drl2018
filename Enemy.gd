extends KinematicBody2D

# include
export(String, FILE, "*.tscn") var bulletSceneFile = "res://EnemyShot.tscn"
var bulletScene = load(bulletSceneFile)

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

# extra
export(String) var playerName = "Player"

export(float) var animationSpeed = 0.1
var animationCounter = 0

var enemyManager

# Commented out due crashes
#func _process(delta):
	#var engineSprite = $engine
	#
	#animationCounter += animationSpeed * delta
	#if animationCounter > 1:
	#	engineSprite.frame = (engineSprite.frame + 1)
	#	print (str(engineSprite.frame))
	#	if engineSprite.frame >= engineSprite.vframes - 1:
	#		engineSprite.frame = 0
	#		

func _ready():
	lastPos = global_position
	enemyManager = get_parent()

func startMove():
	lastPos = global_position
	targetPos = lastPos + direction * moveSpeed
			
func endMove():
	pass

func hit(damageAmount):
	health -= damageAmount
	if health <= 0:
		killMe = true

func canBeDestroyed():
	return killMe

func move(var moveProgressPercentage):
	var nextPos = lastPos.linear_interpolate(targetPos, moveProgressPercentage)
	var collision = move_and_collide(nextPos - lastPos)
	
	var shootTarget = getPlayerPos()
	if shootTarget:
		shootAt(shootTarget)
	
	if collision:
		killMe = true
		if collision.collider.get_name() == playerName:
			collision.collider.hit(collisionDamage)

func shootAt(shootTarget):
	shootTurnCounter += 1
	if shootTurnCounter >= shootingTurnInterval:
		shootTurnCounter = 0
		var bullet = bulletScene.instance()
		enemyManager.add_child(bullet)
		enemyManager.enemyBullets.append(bullet)
		var shootDir = lastPos - shootTarget
		shootDir = shootDir.normalized()
		bullet.setDirection(shootDir)
		bullet.setPlayerName(playerName)
		bullet.startMove()
		
func getPlayerPos():
	var playerNode = get_node("/root/Game/" + playerName)
	if playerNode:
		var playerPos = playerNode.global_position
		return playerPos
	
