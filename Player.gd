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
	none,
  	singleShot,
	railGun,
	laser,
	spreadShot,
	blow,
	groundBomb,
	homing,
	chargeShot
}

var coreAbilityNames = ["Shield", "Probe", "Teleport", "DamageBoost", "Bomb"]
var corePowers = [90,10,50,30,60]
var gunNames = ["None", "Single Shot", "Rail Gun", "Laser", "Spread Shot", "Blow", "Ground Bomb", "Homing", "Charge Shot"]
var gunPowers = [0,5,20,10,15,10,15,10,30]
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

var core = CORE.teleport
var structure = STRUCTURE.medium
var hull = HULL.medium
var engine = ENGINE.fast
var thruster = THRUSTER.balanced
var gun1 = GUN.singleShot
var gun2 = GUN.laser

var currentMovementArea
var movementAreas

var bullets = []
var levelPieces = []
var singleShot = preload("res://SingleShot.tscn")

func _ready():
	levelPieces.append(get_parent().find_node("Level"))
	$ActionUI.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	resolution.x = ProjectSettings.get_setting("display/window/size/width")
	resolution.y = ProjectSettings.get_setting("display/window/size/height")
	movementAreas = [$MovementArea1, $MovementArea1, $MovementArea1]
	currentMovementArea = $MovementArea1
	start_movement_scale = currentMovementArea.scale.x
	_update_gear()
	currentArmor = maxArmor
	_update_gear_values()

func _process(delta):
	mousePos = get_viewport().get_mouse_position()
	mousePos.x = clamp(mousePos.x, 0, resolution.x)
	mousePos.y = clamp(mousePos.y, 0, resolution.y)
	 
	if(my_turn):
		$Cursor.modulate = Color(0,0,0) if Input.is_action_pressed("press") else Color(1,1,1)
		_we()
	else:
		$Cursor.modulate = Color(0,0,0)
		_go()
		turnVal += delta * (1 / turn_time)
		if(turnVal >= 1.0):
			my_turn = true
			currentMovementArea.show()
			currentPower += 5
			wallHit = false
			_update_gear_values()
			
	$Cursor.global_position = mousePos;

func _we():
	pass

func _go():
	var prevPos = global_position
	var nextPos = oldPos.linear_interpolate(targetPos, turnVal)
	var collision = move_and_collide(nextPos - global_position)
	
	if collision and not wallHit:
		global_position = prevPos
		targetPos = prevPos
		wallHit = true
		hit(8)
		
	global_position.x = clamp(global_position.x, 0, resolution.x);
	global_position.y = clamp(global_position.y, 0, resolution.y - 32);	
	
	for b in bullets:
		b.move(turnVal)
		if b.killMe:
			b.queue_free()
			bullets.erase(b)
			
	for l in levelPieces:
		l.move(turnVal)
		if l.killMe:
			l.queue_free()
			levelPieces.erase(l)

func _update_gear():
	currentMovementArea.hide()
	currentMovementArea = movementAreas[thruster]
	currentMovementArea.scale = Vector2(start_movement_scale * movementScales[engine], currentMovementArea.scale.y)
	currentMovementArea.show()
	
	maxArmor = armorValues[hull]
	
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
	
func _update_gear_values():
	
	var tempStr = "%s [-%s]"
	tempStr = tempStr % [gunNames[gun1], gunPowers[gun1]]
	_set_action_button($ActionUI/Button1, tempStr, gun1 == GUN.none or currentPower < gunPowers[gun1])
	
	tempStr = "%s [-%s]"
	tempStr = tempStr % [gunNames[gun2], gunPowers[gun2]]
	_set_action_button($ActionUI/Button2, tempStr, gun2 == GUN.none or currentPower < gunPowers[gun2])
	
	tempStr = "%s [-%s]"
	tempStr = tempStr % [coreAbilityNames[core], corePowers[core]]
	_set_action_button($ActionUI/Button3, tempStr, currentPower < corePowers[core])
	
	_set_action_button($ActionUI/Button4, "Only move", false)
	
	maxPower = maxPowers[core]
	currentPower = clamp(currentPower, 0, maxPower)
	
	tempStr = "Power: %d/%d"
	get_parent().get_node("BottomUI/PowerLabel").text = tempStr % [currentPower, maxPower]
	
	tempStr = "Armor: %d/%d"
	get_parent().get_node("BottomUI/ArmorLabel").text = tempStr % [currentArmor, maxArmor]
	
	tempStr = "Money: %d"
	get_parent().get_node("BottomUI/MoneyLabel").text = tempStr % [money]

func _set_action_button(var button, var name, var disabled):
	button.text = name
	button.disabled = disabled

func _selectAction(var actionNumber):
	my_turn = false
	targetPos = $ActionUI.rect_global_position
	$ActionUI.hide()
	currentMovementArea.hide()
	turnVal = 0.0
	
	for b in bullets:
		b.startMove()
		
	for l in levelPieces:
		l.startMove()
	
func _on_Button1_pressed():
	currentPower -= gunPowers[gun1]
	_selectAction(0)
	_update_gear_values()
	_shoot()

func _on_Button2_pressed():
	currentPower -= gunPowers[gun2]
	_selectAction(1)
	_update_gear_values()
	_shoot()

func _on_Button3_pressed():
	_selectAction(2)
	currentPower -= corePowers[core]
	
	match core:
		CORE.teleport:
			oldPos = targetPos
			global_position = targetPos
			
	_update_gear_values()

func _on_Button4_pressed():
	_selectAction(3)
	_update_gear_values()

func _shoot():
	var bullet = singleShot.instance()
	bullet.position = Vector2(global_position.x + 10, global_position.y)
	get_parent().add_child(bullet)
	bullet.startMove()
	bullets.append(bullet)
	
func hit(var damage):
	currentArmor -= damage
	if(currentArmor <= 0):
		get_tree().reload_current_scene()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("press"):
		$ActionUI.rect_global_position = mousePos;
		$ActionUI.show()
		oldPos = global_position
