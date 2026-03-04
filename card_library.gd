class_name CardLibrary extends Node
var card_scene = preload("res://card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func has_twins(cs: Array[Card]) -> bool:
	var twins = 0
	for card in cs:
		if card.card_labels.find('twin') >= 0:
			twins += 1
	return twins == 2

func make_card_by_name(card_name: String, main: Main) -> Card:
	var card = card_scene.instantiate()
	card.card_name = card_name
	if card_name == 'one':
		card.number = 1
		card.damage = 0
		card.suit = Enums.Suit.RED
		card.dodge = 2
	elif card_name == 'two':
		card.number = 2
		card.damage = 0
		card.suit = Enums.Suit.RED
		card.shield = 1
	elif card_name == 'three':
		card.number = 3
		card.damage = 1
		card.suit = Enums.Suit.RED
	elif card_name == 'chain_strike':
		card.number = 1
		card.damage = 0
		card.description = "one damage per card in chain"
		card.suit = Enums.Suit.RED
		card.first_pass = func (result, enemy, main, cards):
			result.damage += cards.size()
	elif card_name == 'red twin':
		card.number = 2
		card.damage = 1
		card.description = "+2 damage if exactly 2 twins in chain"
		card.suit = Enums.Suit.RED
		card.card_labels.append('twin')
		card.first_pass = func (result, enemy, main, cards):
			result.damage += card.damage
			if has_twins(cards):
				result.damage += 2
	elif card_name == 'green twin':
		card.number = 3
		card.dodge = 2
		card.damage = 0
		card.description = "+2 dodge if exactly 2 twins in chain"
		card.suit = Enums.Suit.GREEN
		card.card_labels.append('twin')
		card.first_pass = func (result, enemy, main, cards):
			result.dodge += card.dodge
			if has_twins(cards):
				result.dodge += 2
	elif card_name == 'blue twin':
		card.number = 1
		card.shield = 1
		card.damage = 0
		card.description = "+2 shield if exactly 2 twins in chain"
		card.suit = Enums.Suit.BLUE
		card.card_labels.append('twin')
		card.first_pass = func (result, enemy, main, cards):
			result.shield += card.shield
			if has_twins(cards):
				result.shield += 2
	elif card_name == 'double_dmg':
		card.number = 1
		card.damage = 0
		card.description = "double damage of chain"
		card.suit = Enums.Suit.RED
		card.second_pass = func(result, enemy, main, cards):
			result.damage *= 2
	else:
		print("Unrecognized card name", card_name)
		return null
	return card
