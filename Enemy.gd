extends KinematicBody2D

# include
export(String, FILE, "*.tscn") var bulletSceneFile = "res://EnemyShot.tscn"
var bulletScene = load(bulletSceneFile)

export(int) var shootingTurnInterval = 1

# Movement
var lastPos
var targetPos
var direction
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

func _process(delta):
	var engineSprite = $engine
	
	animationCounter += animationSpeed * delta
	if animationCounter > 1:
		engineSprite.frame = (engineSprite.frame + 1)
		print (str(engineSprite.frame))
		if engineSprite.frame >= engineSprite.vframes - 1:
			engineSprite.frame = 0
			

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	lastPos = global_position
	pass

func startMove():
	lastPos = global_position
	targetPos = lastPos + direction * moveSpeed
	
	var childArray = get_children()
	for child in childArray:
		if child is bulletScene:
			child.startMove()

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

	# handle bullets
	var childArray = get_children()
	for child in childArray:
		if child is bulletScene:
			child.move(moveProgressPercentage)
			if child.canBeDestroyed():
				remove_child(child)
				child.queue_free()
	
	if collision:
		killMe = true
		if collision.collider.get_name() == playerName:
			collision.collider.hit(collisionDamage)

func shootAt(shootTarget):
	shootTurnCounter += 1
	if shootTurnCounter >= shootingTurnInterval:
		shootTurnCounter = 0
		var bullet = instance(bulletScene)
		add_child(bullet)
		var shootDir = lastPos - shootTarget
		shootDir = shootDir.normalized()
		bullet.setDirection(shootDir)
		bullet.setPlayerName(playerName)
		
func getPlayerPos():
	if _is_inside_tree():
		var playerNode = get_node("/root/" + playerName)
		if playerNode:
			var playerPos = playerNode.global_position
			return playerPos
	
