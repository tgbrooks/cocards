class_name CardLibrary extends Node
var card_scene = preload("res://card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func make_card_by_name(card_name: String, main: Main) -> Card:
	var card = card_scene.instantiate()
	card.card_name = card_name
	if card_name == 'one':
		card.number = 1
		card.suit = Enums.Suit.RED
	elif card_name == 'two':
		card.number = 2
		card.suit = Enums.Suit.RED
	elif card_name == 'three':
		card.number = 3
		card.suit = Enums.Suit.RED
	elif card_name == 'chain_strike':
		card.number = 1
		card.damage = 0
		card.description = "one damage per card in chain"
		card.suit = Enums.Suit.RED
		card.played.connect(func (enemy, cs): enemy.take_damage(cs.size()))
	else:
		print("Unrecognized card name", card_name)
		return null
	return card
