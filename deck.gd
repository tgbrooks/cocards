class_name Deck extends Node2D

var cards: Array[Card] = []

func append(card: Card) -> void:
	var old_position = to_local(card.global_position)
	if card.get_parent():
		card.get_parent().remove_child(card)
	add_child(card)
	cards.append(card)
	card.position = old_position

func pop() -> Card:
	var card = cards.pop_back()
	if card:
		var old_pos = card.global_position
		remove_child(card)
		card.global_position = old_pos
	return card

func shuffle() -> void:
	cards.shuffle()

func _process(delta):
	var to_pos = Vector2(0,0)
	for card in cards:
		var dist = to_pos.distance_to(card.position)
		if dist < 1.5:
			card.position = to_pos
		else:
			var factor = 0.0001**delta
			card.position = to_pos * (1-factor) + card.position*factor
