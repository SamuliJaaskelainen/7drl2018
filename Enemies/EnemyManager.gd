extends Node

var enemies = []
var enemyBullets = []

func startMove():	
	for e in enemies:
		e.startMove()
	for b in enemyBullets:
		b.startMove()

func moveEnemies(var turnVal):		
	for e in enemies:
		e.move(turnVal)
		if e.killMe:
			e.queue_free()
			enemies.erase(e)
			
	for b in enemyBullets:
		b.move(turnVal)
		if b.killMe:
			b.queue_free()
			enemyBullets.erase(b)
			
func endMove():
	for e in enemies:
		e.endMove()
	for b in enemyBullets:
		b.endMove()
