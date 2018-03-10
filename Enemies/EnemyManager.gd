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
		if e.killMe or e.global_position.x < -16:
			e.queue_free()
			enemies.erase(e)
			
	for b in enemyBullets:
		b.move(turnVal)
		if b.killMe or b.global_position.x < -16:
			b.queue_free()
			enemyBullets.erase(b)
			
func endMove():
	for e in enemies:
		e.endMove()
	for b in enemyBullets:
		b.endMove()
