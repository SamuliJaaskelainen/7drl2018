extends Node

# Pieces currently in level
var currentLevel = []

# Pieces used in random pool
var levelPieces = []

# Add pieces here, piece1, piece2, piece3 etc.
# Pieces should be in LevelPieces folder
# Each piece var needs to point to different level piece
# MIGI ADD NEW PIECES HERE
var piece1 = preload("res://LevelPieces/LevelPiece1.tscn")
var piece2 = preload("res://LevelPieces/LevelPiece2.tscn")
var piece3 = preload("res://LevelPieces/LevelPiece3.tscn")
var piece4 = preload("res://LevelPieces/LevelPiece4.tscn")
var piece5 = preload("res://LevelPieces/LevelPiece5.tscn")
var piece6 = preload("res://LevelPieces/LevelPiece6.tscn")
var piece7 = preload("res://LevelPieces/LevelPiece7.tscn")
var piece8 = preload("res://LevelPieces/LevelPiece8.tscn")

func _ready():
	# Here add pieces that you want to use to levelPieces list
	# Comment out with #-sign pieces you don't want in your random pool
	# MIGI COMMENT OUT PIECES YOU DON'T WANT TO TEST
	levelPieces.append(piece1)
	#levelPieces.append(piece2)
	#levelPieces.append(piece3)
	#levelPieces.append(piece4)
	levelPieces.append(piece5)
	levelPieces.append(piece6)
	levelPieces.append(piece7)
	levelPieces.append(piece8)
	
	# Once all pieces are added we generate initial level
	generateLevel()

func generateLevel():
	# When game is booted, we need to add beginning piece
	if currentLevel.size() == 0:
		createPiece(Vector2(256,128))
	
	# Piece sizes are hardcoded
	createPiece(Vector2(768,128))

# Pick a piece and spawn it, this is called when current piece goes out of screen
func createPiece(var pos):
	var level = levelPieces[randi()%levelPieces.size()].instance()
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
	
