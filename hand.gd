class_name Hand extends Node2D

signal card_selected(card: Card)
var hand: Array[Card] = []
var padding = 10
var selected_card: Card = null
var deck: Array[Card] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func make_deck(main:Main) -> void:
	var library = CardLibrary.new()
	for enemy_name in ["smite", "smite", "shield", "magic_missile", "magic_missile"]:
		deck.append(library.make_card_by_name(enemy_name, main))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position_hand()
	
func deal_hand() -> void:
	# Drop old cards
	for card in hand:
		card.queue_free()
	hand = []

	# make new hand
	for i in range(10):
		var new_card = deck.pop_back()
		if not new_card:
			break
		new_card.pressed.connect(func (): card_selected.emit(new_card))
		self.add_child(new_card)
		hand.append(new_card)

func position_hand() -> void:
	var pos = 0
	for i in range(hand.size()):
		var card = hand[i]
		card.position = Vector2(pos, 0)
		pos += card.size.x + padding

func _on_card_selected(card: Card) -> void:
	card.select()
	if selected_card:
		selected_card.unselect()
	selected_card = card
