extends Control

var boughtAmount
var items = []
var itemTypes = []

var corePrices = [1,2,3,4,5]
var structurePrices = [1,2,3]
var hullPrices = [1,2,3]
var enginePrices = [1,2,3]
var thrusterPrices = [1,2,3]
var gunPrices = [1,2,3,4,5,6,7,8]

var coreTexts = ["Shield","Probe","Teleport","Damage boost","Bomb"]
var structureTexts = ["Small","Medium","Large"]
var hullTexts = ["Light","Medium","Heavy"]
var engineTexts = ["Slow","Medium","Fast"]
var thrusterTexts = ["Agile","Balanced","Fast"]
var gunTexts = ["Single shot","Laser","Rail shot","Spread shot","Blow","Ground bomb","Homing","Charge"]

var player 

func show():
	player = get_parent().get_node("Player")
	boughtAmount = 0
	items = []
	itemTypes = []
	addItem(player.GUN.spreadShot, player.GUN, $ShopItem1, $ShopItem1Buy)
	addItem(player.HULL.light, player.HULL, $ShopItem2, $ShopItem2Buy)
	addItem(player.ENGINE.slow, player.ENGINE, $ShopItem3, $ShopItem3Buy)
	visible = true
	
func addItem(var item, var type, var shopItem, var shopItemBuy):
	items.append(item)
	itemTypes.append(type)
	
	match type:
		player.CORE:
			shopItem.text = coreTexts[item]
		player.STRUCTURE:
			shopItem.text = structureTexts[item]
		player.HULL:
			shopItem.text = hullTexts[item]
		player.ENGINE:
			shopItem.text = engineTexts[item]
		player.THRUSTER:
			shopItem.text = thrusterTexts[item]
		player.GUN:
			shopItem.text = gunTexts[item]
	
	shopItemBuy.text = "BUY ["
	match type:
		player.CORE:
			shopItemBuy.text += str(corePrices[item]) 
		player.STRUCTURE:
			shopItemBuy.text += str(structurePrices[item])
		player.HULL:
			shopItemBuy.text += str(hullPrices[item])
		player.ENGINE:
			shopItemBuy.text += str(enginePrices[item])
		player.THRUSTER:
			shopItemBuy.text += str(thrusterPrices[item])
		player.GUN:
			shopItemBuy.text += str(gunPrices[item])
	shopItemBuy.text += "]"
	
	
func hide():
	visible = false

func _on_ShopItem1Buy_pressed():
	buyItem(items[0], itemTypes[0], $ShopItem1, $ShopItem1Buy)

func _on_ShopItem2Buy_pressed():
	buyItem(items[1], itemTypes[1], $ShopItem2, $ShopItem2Buy)

func _on_ShopItem3Buy_pressed():
	buyItem(items[2], itemTypes[2], $ShopItem3, $ShopItem3Buy)

func _on_ShopClose_pressed():
	hide()
	
func buyItem(var item, var type, var shopItem, var shopItemBuy):
	
	match type:
		player.CORE:
			player.core = item
		player.STRUCTURE:
			player.structure = item
		player.HULL:
			player.hull = item
		player.ENGINE:
			player.engine = item
		player.THRUSTER:
			player.thruster = item
		player.GUN:
			player.gun2 = item
			
	player.update_gear()
	player.update_gear_values()
	
	shopItem.visible = false
	shopItemBuy.visible = false
	boughtAmount += 1
	if boughtAmount >= 3:
		hide()
