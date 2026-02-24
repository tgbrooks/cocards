class_name CardStack extends Node2D

var cards: Array[Card] = []
var padding: float = 10.0
var reference: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if reference:
		position = reference.position + Vector2(0, reference.size.y + padding);
	var curr_height = 0;
	for i in range(cards.size()):
		var card = cards[i]
		var to_pos: Vector2 = Vector2(0, curr_height)
		var dist = to_pos.distance_to(card.position)
		if dist < 1.5:
			card.position = to_pos
		else:
			var factor = 0.0001**delta
			card.position = to_pos * (1-factor) + card.position*factor
		curr_height += card.size.y + padding

func append(card: Card) -> void:
	cards.append(card)
	var old_pos = to_local(card.global_position)
	var parent = card.get_parent()
	if parent:
		parent.remove_child(card)
	if parent is CardStack:
		parent.cards.remove_at(parent.cards.find(card))
	card.position = old_pos
	add_child(card)

func remove(card: Card) -> Card:
	var idx = cards.find(card)
	if idx >= 0:
		return cards.pop_at(idx)
	return null

func card_pressed(card: Card) -> void:
	var idx = cards.find(card)
	if idx == -1:
		print("ERROR: Selecting from the wrong card stack")
		return
	var these_cards = cards.slice(idx)
	if not Card.can_chain(these_cards):
		return
	get_parent().cards_activated(these_cards, self)
