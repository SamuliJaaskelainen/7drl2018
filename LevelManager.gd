extends Node

# Pieces currently in level
var currentLevel = []

# Pieces used in random pool
var levelPieces = []

# Pieces used in random pool
var allLevelPieces = []

# Values to controls piece pool
var pieceSpawnCount = 0
var poolIndex
var movePoolRate = 4
var startPoolSize = 5

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
var piece9 = preload("res://LevelPieces/LevelPiece9.tscn")
var piece10 = preload("res://LevelPieces/LevelPiece10.tscn")
var piece11 = preload("res://LevelPieces/LevelPiece11.tscn")
var piece12 = preload("res://LevelPieces/LevelPiece12.tscn")
var piece13 = preload("res://LevelPieces/LevelPiece13.tscn")
var piece14 = preload("res://LevelPieces/LevelPiece14.tscn")


func _ready():
	# Here add pieces that you want to use to levelPieces list
	# Comment out with #-sign pieces you don't want in your random pool
	# MIGI COMMENT OUT PIECES YOU DON'T WANT TO TEST
	#allLevelPieces.append(piece1)
	allLevelPieces.append(piece2)
	allLevelPieces.append(piece3)
	allLevelPieces.append(piece4)
	allLevelPieces.append(piece5)
	allLevelPieces.append(piece6)
	allLevelPieces.append(piece7)
	allLevelPieces.append(piece8)
	allLevelPieces.append(piece9)
	allLevelPieces.append(piece10)
	allLevelPieces.append(piece11)
	allLevelPieces.append(piece12)
	allLevelPieces.append(piece13)
	allLevelPieces.append(piece14)
	
	# Add initial pool
	for i in startPoolSize:
		levelPieces.append(allLevelPieces[i])
		print(i)
	poolIndex = 4
	
	# Once all pieces are added we generate initial level
	generateLevel()

func refreshPool():
	pieceSpawnCount = 0
	poolIndex += 1
	if poolIndex < allLevelPieces.size():
		levelPieces.pop_front()
		levelPieces.append(allLevelPieces[poolIndex])
		
	print("Refresh pool")
	for p in levelPieces:
		print(p)

func generateLevel():
	pieceSpawnCount += 1
	if(pieceSpawnCount >= movePoolRate):
		refreshPool()
	
	# When game is booted, we need to add beginning piece
	if currentLevel.size() == 0:
		createPiece(Vector2(256,128))
	
	# Piece sizes are hardcoded
	createPiece(Vector2(768,128))

# Pick a piece and spawn it, this is called when current piece goes out of screen
func createPiece(pos):
	var level = levelPieces[randi()%levelPieces.size()].instance()
	add_child(level)
	print("Create level piece")
	level.global_position = pos
	print(pos)
	level.startMove()
	currentLevel.append(level)

func startMove():	
	for l in currentLevel:
		l.startMove()

func moveLevel(turnVal):		
	for l in currentLevel:
		l.move(turnVal)
		if l.killMe:
			l.queue_free()
			currentLevel.erase(l)
			generateLevel()
	
