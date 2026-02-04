class_name CardStack extends Node2D

var cards: Array[Card] = []
var padding: float = 10.0
var reference: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if reference:
		position = reference.position + Vector2(0, reference.size.y + padding);
	var curr_height = 0;
	for i in range(cards.size()):
		var card = cards[i]
		card.position = Vector2(0, curr_height)
		curr_height += card.size.y + padding

func append(card: Card) -> void:
	cards.append(card)
	var parent = card.get_parent()
	if parent:
		parent.remove_child(card)
	if parent is CardStack:
		parent.cards.remove_at(parent.cards.find(card))
	if parent is Hand:
		parent.hand.remove_at(parent.hand.find(card))
	add_child(card)
