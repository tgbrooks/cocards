class_name CardStack extends Node2D

var cards: Array[Card]:
	get():
		var my_cards: Array[Card] = []
		for node in get_children():
			if node is Card:
				my_cards.append(node)
		return my_cards

var padding: float = 10.0
@onready var background_button: Button = $BackgroundButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background_button.pressed.connect(stack_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
		curr_height += 50 #card.button.size.y + padding

func append(card: Card) -> void:
	var old_pos = to_local(card.global_position)
	var parent = card.get_parent()
	if parent:
		parent.remove_child(card)
	card.position = old_pos
	add_child(card)

func remove(card: Card):
	remove_child(card)

func card_pressed(card: Card) -> void:
	var idx = cards.find(card)
	if idx == -1:
		print("ERROR: Selecting from the wrong card stack")
		return
	var these_cards = cards.slice(idx)
	if not Card.can_chain(these_cards):
		return
	get_parent().cards_activated(these_cards, self)

func stack_pressed() -> void:
	if cards:
		# There is a card here so we act like we click on the card
		var bottom_card = cards[cards.size()-1]
		card_pressed(bottom_card)
	else:
		# Empty cards activated onto here to move any selected cards to us
		var empty: Array[Card] = []
		get_parent().cards_activated(empty, self)
