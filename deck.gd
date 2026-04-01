class_name Deck extends Node2D

@export var data: DeckData
var game_view: GameView

func _read():
	data.card_appended.connect(_on_appended)
	data.card_removed.connect(_on_pop)

func _on_appended(card_data: CardData) -> void:
	var card = game_view.lookup_card(card_data)
	var old_position = to_local(card.global_position)
	if card.get_parent():
		card.get_parent().remove_child(card)
	add_child(card)
	card.position = old_position

func _on_pop(card_data: CardData):
	var card = game_view.lookup_card(card_data)
	var old_pos = card.global_position
	remove_child(card)
	card.global_position = old_pos
	return card

func _process(delta):
	var to_pos = Vector2(0,0)
	for card in self.get_children():
		if card is not Card:
			continue
		var dist = to_pos.distance_to(card.position)
		if dist < 1.5:
			card.position = to_pos
		else:
			var factor = 0.0001**delta
			card.position = to_pos * (1-factor) + card.position*factor
