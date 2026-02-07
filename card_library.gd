class_name CardLibrary extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func make_card_by_name(card_name: String, main: Main) -> Card:
	var card = Card.new()
	card.card_name = card_name
	if card_name == 'lever':
		card.work = 1
		card.oil = 1
	elif card_name == 'force':
		card.heat = 1
		card.work = 1
		card.oil = 1
	elif card_name == 'lubricate':
		card.oil = 2
		card.heat = 1
	else:
		print("Unrecognized card name", card_name)
		return null
	return card
