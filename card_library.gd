class_name CardLibrary extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func make_card_by_name(card_name: String, main: Main) -> Card:
	var reward_1g = func():
		main.gain_coins.emit(1)
	var reward_1c = func():
		main.gain_charges.emit(1)
	var card = Card.new()
	card.card_name = card_name
	if card_name == 'smite':
		card.attack = 1
		card.defense = 1
		card.played.connect(func(enemy): enemy.defeated.connect(reward_1g))
	elif card_name == 'shield':
		card.attack = 0
		card.defense = 2
		card.played.connect(func(enemy): enemy.defeated.connect(reward_1c))
	elif card_name == 'magic_missile':
		card.attack = 2
		card.defense = 0
	else:
		print("Unrecognized card name", card_name)
		return null
	return card
