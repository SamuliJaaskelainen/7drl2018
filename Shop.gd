extends Control

var boughtAmount
var items = []
var itemTypes = []
var itemPrices = []

func show():
	boughtAmount = 0
	items = []
	itemTypes = []
	addItem(0,0)
	addItem(0,0)
	addItem(0,0)
	visible = true
	
func addItem(var item, var type):
	items.append(item)
	itemTypes.append(type)
	
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
	
func buyItem(var item, var itemType, var shopItem, var shopItemBuy):
	shopItem.visible = false
	shopItemBuy.visible = false
	boughtAmount += 1
	if boughtAmount >= 3:
		hide()
