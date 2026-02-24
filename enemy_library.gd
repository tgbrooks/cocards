class_name EnemyLibrary extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func make_enemy_by_name(enemy_name: String, main: Main) -> Enemy:
	var enemy = Enemy.new()
	enemy.enemy_name = enemy_name
	if enemy_name == 'grunt':
		enemy.health = 5
		enemy.attack = 1
	elif enemy_name == 'mage':
		enemy.health = 3
		enemy.attack = 3
	else:
		print("Unrecognized enemy name", enemy_name)
		return null
	return enemy
