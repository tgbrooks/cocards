class_name EnemyLibrary extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func make_enemy_by_name(enemy_name: String, main: Main) -> Enemy:
	
	var _poison = func ():
		print("poisoning!")
		main.players_damaged.emit(1)
	var _reward_charge = func ():
		main.gain_charges.emit(1)
	var _reward_coin = func():
		main.gain_coins.emit(1)
	var enemy = Enemy.new()
	enemy.enemy_name = enemy_name
	if enemy_name == 'grunt':
		enemy.attack = 4
		enemy.health = 4
		enemy.defeated.connect(_reward_coin)
	elif enemy_name == 'slime':
		enemy.attack = 1
		enemy.health = 4
		enemy.survived.connect(_poison)
	elif enemy_name == 'mage':
		enemy.attack = 6
		enemy.health = 1
		enemy.defeated.connect(_reward_charge)
	else:
		print("Unrecognized enemy name", enemy_name)
		return null
	return enemy
