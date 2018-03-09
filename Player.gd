extends KinematicBody2D

enum CORE{
  	shield,
  	probe,
	teleport,
	damageBoost,
	bomb
}

enum STRUCTURE{
  	small,
	medium,
	large
}

enum HULL{
  	light,
	medium,
	heavy
}

enum ENGINE{
  	slow,
	medium,
	fast
}

enum THRUSTER{
  	agile,
	balanced,
	fast
}

enum GUN{
  	singleShot,
	laser,
	railGun,
	spreadShot,
	blow,
	groundBomb,
	homing,
	chargeShot
}

var coreAbilityNames = ["Shield", "Probe", "Teleport", "DamageBoost", "Bomb"]
var corePowers = [90,10,50,30,60]
var gunNames = ["Single Shot", "Laser", "Rail Gun", "Spread Shot", "Blow", "Ground Bomb", "Homing", "Charge Shot"]
var gunPowers = [5,10,40,20,10,15,10,30]
var maxPowers = [100,100,100,100,100]
var structureNames = ["Small", "Medium", "Large"]
var hullNames = ["Light", "Medium", "Heavy"]
var engineNames = ["Slow", "Medium", "Fast"]
var thrusterNames = ["Agile", "Balanced", "Fast"]
var movementScales = [0.75,1,1.25]
var start_movement_scale
var armorValues = [80,100,120]

var resolution = Vector2()
var mousePos = Vector2()
var oldPos = Vector2()
var targetPos = Vector2()
var turnVal = 0.0
var turn_time = 0.33
var my_turn = true;
var currentPower = 20
var maxPower = 0
var currentArmor = 0
var maxArmor = 0
var wallHit = false
var money = 0
var powerPerTurn = 5

var core = CORE.teleport
var structure = STRUCTURE.medium
var hull = HULL.medium
var engine = ENGINE.fast
var thruster = THRUSTER.balanced
var gun1 = GUN.singleShot
var gun2 = GUN.blow

var currentMovementArea
var movementAreas
var canDoAction = false

var shotBullets = []
var bullets = []
var gun1Bullet
var gun2Bullet
var singleShot = preload("res://Guns/SingleShot.tscn")
var laserShot = preload("res://Guns/LaserShot.tscn")
var railShot = preload("res://Guns/RailShot.tscn")
var spreadShot = preload("res://Guns/SpreadShot.tscn")
var blowShot = preload("res://Guns/BlowShot.tscn")

var levelManager
var enemyManager
var shop

func _ready():
	randomize()
	levelManager = get_parent().get_node("LevelManager")
	enemyManager = get_parent().get_node("EnemyManager")
	shop = get_parent().get_node("Shop")
	bullets.append(singleShot)
	bullets.append(laserShot)
	bullets.append(railShot)
	bullets.append(spreadShot)
	bullets.append(blowShot)
	$ActionUI.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	resolution.x = ProjectSettings.get_setting("display/window/size/width")
	resolution.y = ProjectSettings.get_setting("display/window/size/height")
	movementAreas = [$MovementArea1, $MovementArea1, $MovementArea1]
	currentMovementArea = $MovementArea1
	start_movement_scale = currentMovementArea.scale.x
	update_gear()
	currentArmor = maxArmor
	update_gear_values()
	shop.hide()

func _process(delta):
	mousePos = get_viewport().get_mouse_position()
	mousePos.x = clamp(mousePos.x, 0, resolution.x)
	mousePos.y = clamp(mousePos.y, 0, resolution.y)
	 
	if(my_turn):
		$Cursor.modulate = Color(0,0,0) if Input.is_action_pressed("press") else Color(1,1,1)
		we()
	else:
		$Cursor.modulate = Color(0,0,0)
		go()
		turnVal += delta * (1 / turn_time)
		if(turnVal >= 1.0):
			nextTurn()
			
	$Cursor.global_position = mousePos;

func nextTurn():
	my_turn = true
	currentMovementArea.show()
	currentPower += powerPerTurn
	wallHit = false
	update_gear_values()
	enemyManager.endMove()
	
	for b in shotBullets:
		b.endMove()
		if b.killMe:
			b.queue_free()
			shotBullets.erase(b)
	
func we():
	if not canDoAction:
		return
	
	# Player's turn logic is handled via ui signals as well
	# Here we have hotkeys for leet players
	#if $ActionUI.is_visible_in_tree():
	if Input.is_action_just_pressed("action1") and not $ActionUI/Button1.disabled:
		_on_Button1_pressed()
			
	#if $ActionUI.is_visible_in_tree():
	if Input.is_action_just_pressed("action2") and not $ActionUI/Button2.disabled:
		_on_Button2_pressed()
			
	#if $ActionUI.is_visible_in_tree():
	if Input.is_action_just_pressed("action3") and not $ActionUI/Button3.disabled:
		_on_Button3_pressed()
			
	#if $ActionUI.is_visible_in_tree():
	if Input.is_action_just_pressed("action4") and not $ActionUI/Button4.disabled:
		_on_Button4_pressed()
		
	if Input.is_action_just_pressed("skip"):
		skip_turn()

func go():
	var prevPos = global_position
	var nextPos = oldPos.linear_interpolate(targetPos, turnVal)
	var collision = move_and_collide(nextPos - global_position)
	
	if collision:
		if "Power" in collision.collider.get_name():
			currentPower += 30
			collision.collider.queue_free()
		elif "Armor" in collision.collider.get_name():
			currentArmor += 5
			collision.collider.queue_free()
		elif "Money" in collision.collider.get_name():
			money += 10
			collision.collider.queue_free()
		elif "Shop" in collision.collider.get_name():
			shop.show()
			collision.collider.queue_free()
		elif not wallHit:
			global_position = prevPos
			targetPos = prevPos
			wallHit = true
			hit(8)
		
	global_position.x = clamp(global_position.x, 0, resolution.x);
	global_position.y = clamp(global_position.y, 0, resolution.y - 32);	
	
	for b in shotBullets:
		b.move(turnVal)
		if b.killMe:
			b.queue_free()
			shotBullets.erase(b)
			
	levelManager.moveLevel(turnVal)
	enemyManager.moveEnemies(turnVal)

func update_gear():
	
	# Movement area
	currentMovementArea.hide()
	currentMovementArea = movementAreas[thruster]
	currentMovementArea.scale = Vector2(start_movement_scale * movementScales[engine], currentMovementArea.scale.y)
	currentMovementArea.show()
	
	# BottomUI
	var tempStr = "Core: %s"
	get_parent().get_node("BottomUI/CoreLabel").text = tempStr % [coreAbilityNames[core]]
	tempStr = "Structure: %s"
	get_parent().get_node("BottomUI/StructureLabel").text = tempStr % [structureNames[structure]]
	tempStr = "Hull: %s"
	get_parent().get_node("BottomUI/HullLabel").text = tempStr % [hullNames[hull]]
	tempStr = "Engine: %s"
	get_parent().get_node("BottomUI/EngineLabel").text = tempStr % [engineNames[engine]]
	tempStr = "Thruster: %s"
	get_parent().get_node("BottomUI/ThrusterLabel").text = tempStr % [thrusterNames[thruster]]
	tempStr = "Gun1: %s"
	get_parent().get_node("BottomUI/Gun1Label").text = tempStr % [gunNames[gun1]]
	tempStr = "Gun2: %s"
	get_parent().get_node("BottomUI/Gun2Label").text = tempStr % [gunNames[gun2]]
	
	# Gear values
	maxArmor = armorValues[hull]
	maxPower = maxPowers[core]
	gun1Bullet = bullets[gun1]
	gun2Bullet = bullets[gun2]
	
func update_gear_values():
	
	# ActionUI
	var tempStr = "1) %s [-%s]"
	tempStr = tempStr % [gunNames[gun1], gunPowers[gun1]]
	_set_action_button($ActionUI/Button1, tempStr, currentPower < gunPowers[gun1])
	tempStr = "2) %s [-%s]"
	tempStr = tempStr % [gunNames[gun2], gunPowers[gun2]]
	_set_action_button($ActionUI/Button2, tempStr, currentPower < gunPowers[gun2])
	tempStr = "3) %s [-%s]"
	tempStr = tempStr % [coreAbilityNames[core], corePowers[core]]
	_set_action_button($ActionUI/Button3, tempStr, currentPower < corePowers[core])
	_set_action_button($ActionUI/Button4, "4) Only move", false)
	
	# BottomUI
	currentPower = clamp(currentPower, 0, maxPower)
	tempStr = "Power: %d/%d"
	get_parent().get_node("BottomUI/PowerLabel").text = tempStr % [currentPower, maxPower]
	tempStr = "Armor: %d/%d"
	currentArmor = clamp(currentArmor, 0, maxArmor)
	get_parent().get_node("BottomUI/ArmorLabel").text = tempStr % [currentArmor, maxArmor]
	tempStr = "Money: %d"
	get_parent().get_node("BottomUI/MoneyLabel").text = tempStr % [money]

func _set_action_button(var button, var name, var disabled):
	button.text = name
	button.disabled = disabled

func base_action():
	my_turn = false
	if $ActionUI.visible:
		targetPos = $ActionUI.rect_global_position
	$ActionUI.hide()
	currentMovementArea.hide()
	turnVal = 0.0
	canDoAction = false
	update_gear_values()
	
	for b in shotBullets:
		b.startMove()
		
	levelManager.startMove()
	enemyManager.startMove()
	
func _on_Button1_pressed():
	currentPower -= gunPowers[gun1]
	base_action()
	shoot(gun1Bullet, gun1)

func _on_Button2_pressed():
	currentPower -= gunPowers[gun2]
	base_action()
	shoot(gun2Bullet, gun2)

func _on_Button3_pressed():
	currentPower -= corePowers[core]
	base_action()
	match core:
		CORE.teleport:
			oldPos = targetPos
			global_position = targetPos	

func _on_Button4_pressed():
	base_action()

func skip_turn():
	oldPos = global_position
	targetPos = global_position
	base_action();

func shoot(gunBullet, gun):
	if (gun == GUN.spreadShot):
		createBullet(gunBullet)
		var bulletUp = createBullet(gunBullet)
		bulletUp.dir = Vector2(1,0.2)
		bulletUp.startMove()
		var bulletDown = createBullet(gunBullet)
		bulletDown.dir = Vector2(1,-0.2)
		bulletDown.startMove()
	else:
		createBullet(gunBullet)
	
func createBullet(gunBullet):
	var bullet = gunBullet.instance()
	bullet.position = Vector2(global_position.x + 16, global_position.y)
	get_parent().add_child(bullet)
	bullet.startMove()
	shotBullets.append(bullet)
	return bullet
	
func hit(damage):
	currentArmor -= damage
	if(currentArmor <= 0):
		currentArmor = 0
		get_tree().reload_current_scene()

func _on_Area2D_input_event(viewport, event, shape_idx):
	canDoAction = true
	targetPos = mousePos
	oldPos = global_position
	if Input.is_action_just_pressed("press"):
		$ActionUI.rect_global_position = mousePos;
		$ActionUI.show()
		oldPos = global_position
