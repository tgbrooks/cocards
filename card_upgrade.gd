class_name CardUpgradeData extends Resource

@export var upgrade_name: String = "upgrade"
@export var damage: int = 0
@export var dodge: int = 0
@export var shield: int = 0
@export var description: String = "MISSING"
@export var labels: Array[String] = []

var first_pass = func(result: StackResults, _enemy: EnemyData, _state: GameState, _cards: Array[CardData]) -> StackResults:
	result.damage += damage
	result.shield += shield
	result.dodge += dodge
	return result

var second_pass = func(result: StackResults, _enemy: EnemyData, _state: GameState, _cards: Array[CardData]) -> StackResults:
	return result
