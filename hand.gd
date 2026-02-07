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
	for enemy_name in ["lever", "lever", "force", "force", "lubricate"]:
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
	if selected_card == card:
		return
	elif selected_card:
		# Insert the previous selection into the new place
		var old_idx = hand.find(selected_card)
		hand.remove_at(old_idx)
		var new_idx = hand.find(card)
		hand.insert(new_idx, selected_card)
		selected_card.unselect()
		selected_card = null
	else:
		card.select()
		selected_card = card
