extends Node

var currentLevel = []
var levelPieces = []
var piece1 = preload("res://LevelPieces/LevelPiece1.tscn")

func _ready():
	levelPieces.append(piece1)
	generateLevel()

func generateLevel():
	if currentLevel.size() == 0:
		createPiece(Vector2(256,128))
	
	createPiece(Vector2(768,128))

func createPiece(var pos):
	var level = levelPieces[0].instance()
	level.position = pos
	add_child(level)
	level.startMove()
	currentLevel.append(level)

func startMove():	
	for l in currentLevel:
		l.startMove()

func moveLevel(var turnVal):		
	for l in currentLevel:
		l.move(turnVal)
		if l.killMe:
			l.queue_free()
			currentLevel.erase(l)
			generateLevel()
	
