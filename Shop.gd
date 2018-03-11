extends Control

var boughtAmount
var items = []
var itemTypes = []
var itemPrices = []

var corePrices = [15,15,15,40]
var structurePrices = [20,25,20,20]
var hullPrices = [30,50,60,4]
var enginePrices = [10,20,50]
var thrusterPrices = [20,30,50,10]
var gunPrices = [10,15,40,40,25,35,20]

var coreTexts = ["CORE: Shield, Next hit no dmg","CORE: Teleport, Appear into new place","CORE: Damage boost, Next shot 1.5x dmg","CORE: Bomb, Clears bullets, 10dmg to all enemies"]
var structureTexts = ["STRUCTURE: Rounded","STRUCTURE: Pipe","STRUCTURE: Large","STRUCTURE: Multi"]
var hullTexts = ["HULL: Light, 80 armor","HULL: Medium, 100 armor","HULL: Heavy, 120 armor"]
var engineTexts = ["ENGINE: Slow","ENGINE: Medium","ENGINE: Fast"]
var thrusterTexts = ["THRUSTER: Agile","THRUSTER: Wide","THRUSTER: Experimental", "THRUSTER: Balanded"]
var gunTexts = ["GUN: Single shot","GUN: Laser","GUN: Rail shot","GUN: Spread shot","GUN: Blow","GUN: Ground bomb","Charge"]

var player 
var audioManager

func _ready():
	player = get_parent().get_node("Player")
	audioManager = $"/root/Game/AudioManager"

func show():
	
	boughtAmount = 0
	items = []
	itemTypes = []
	itemPrices = []
	addItem($ShopItem1, $ShopItem1Buy, randi() % 5)
	addItem($ShopItem2, $ShopItem2Buy, randi() % 5)
	addItem($ShopItem3, $ShopItem3Buy, randi() % 5)
	addItem($ShopItem4, $ShopItem4BuySlot1, 5)
	visible = true
	
func addItem(shopItem, shopItemBuy, rType):
	
	var item
	var type

	match rType:
		0:
			type = player.CORE
		1:
			type = player.STRUCTURE
		2:
			type = player.HULL
		3:
			type = player.ENGINE
		4:
			type = player.THRUSTER
		5:
			type = player.GUN
	
	itemTypes.append(type)
	
	match type:
		player.CORE:
			item = randi()%coreTexts.size()
			shopItem.text = coreTexts[item]
		player.STRUCTURE:
			item = randi()%structureTexts.size()
			shopItem.text = structureTexts[item]
		player.HULL:
			item = randi()%hullTexts.size()
			shopItem.text = hullTexts[item]
		player.ENGINE:
			item = randi()%engineTexts.size()
			shopItem.text = engineTexts[item]
		player.THRUSTER:
			item = randi()%thrusterTexts.size()
			shopItem.text = thrusterTexts[item]
		player.GUN:
			item = randi()%gunTexts.size()
			shopItem.text = gunTexts[item]
	
	items.append(item)
	
	shopItemBuy.text = "BUY ["
	match type:
		player.CORE:
			shopItemBuy.text += str(corePrices[item])
			itemPrices.append(corePrices[item])
		player.STRUCTURE:
			shopItemBuy.text += str(structurePrices[item])
			itemPrices.append(structurePrices[item])
		player.HULL:
			shopItemBuy.text += str(hullPrices[item])
			itemPrices.append(hullPrices[item])
		player.ENGINE:
			shopItemBuy.text += str(enginePrices[item])
			itemPrices.append(enginePrices[item])
		player.THRUSTER:
			shopItemBuy.text += str(thrusterPrices[item])
			itemPrices.append(thrusterPrices[item])
		player.GUN:
			shopItemBuy.text = "BUY Gun1 ["
			shopItemBuy.text += str(gunPrices[item])
			itemPrices.append(gunPrices[item])
			$ShopItem4BuySlot2.text = "BUY Gun2 ["
			$ShopItem4BuySlot2.text += str(gunPrices[item])
			$ShopItem4BuySlot2.text += "]"
			$ShopItem4BuySlot2.visible = true
	shopItemBuy.text += "]"
	
	shopItem.visible = true
	shopItemBuy.visible = true
	
func hide():
	visible = false

func _on_ShopItem1Buy_pressed():
	buyItem(items[0], itemTypes[0], $ShopItem1, $ShopItem1Buy, itemPrices[0], -1)

func _on_ShopItem2Buy_pressed():
	buyItem(items[1], itemTypes[1], $ShopItem2, $ShopItem2Buy, itemPrices[1], -1)

func _on_ShopItem3Buy_pressed():
	buyItem(items[2], itemTypes[2], $ShopItem3, $ShopItem3Buy, itemPrices[3], -1)
	
func _on_ShopItem4BuySlot1_pressed():
	buyItem(items[3], itemTypes[3], $ShopItem4, $ShopItem4BuySlot1, itemPrices[3], 1)
	
func _on_ShopItem4BuySlot2_pressed():
	buyItem(items[3], itemTypes[3], $ShopItem4, $ShopItem4BuySlot1, itemPrices[3], 2)

func _on_ShopClose_pressed():
	audioManager.PlayAudio("ui_select_action_from_action_menu")
	hide()
	
func buyItem(item, type, shopItem, shopItemBuy, price, gunID):
	
	if player.money < price:
		audioManager.PlayAudio("hit_bullet_hits_ground")
		return
		
	audioManager.PlayAudio("ui_buy_from_shop")
	player.money -= price
	
	match type:
		player.CORE:
			player.core = item
		player.STRUCTURE:
			player.structure = item
		player.HULL:
			player.hull = item
			player.currentArmor = player.armorValues[item]
		player.ENGINE:
			player.engine = item
		player.THRUSTER:
			player.thruster = item
		player.GUN:
			if (gunID == 1):
				player.gun1 = item
			else:
				player.gun2 = item
			$ShopItem4BuySlot2.visible = false
			
	player.update_gear()
	player.update_gear_values()
	
	shopItem.visible = false
	shopItemBuy.visible = false
	boughtAmount += 1
	if boughtAmount >= 3:
		hide()






