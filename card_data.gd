class_name CardData extends Resource

@export var card_name: String = "mycard"
@export var number: int = 0 
@export var suit: Enums.Suit = Enums.Suit.RED
@export var visible_face: Enums.CardFace = Enums.CardFace.BACK

@export var upgrades: Array = []

signal card_flipped(new_face: Enums.CardFace)

var card_labels:
	get():
		var labels = []
		for upgrade in upgrades:
			for label in upgrade.labels:
				labels.append(label)
		return labels

func flip_card(face: Enums.CardFace) -> void:
	if face == visible_face:
		return
	visible_face = face
	card_flipped.emit(face)

static func can_chain(cards: Array[CardData]) -> bool:
	print("Checking card chain", cards)
	var curr_number = null
	for card in cards:
		if curr_number == null:
			curr_number = card.number
			continue
		if card.number != curr_number -1:
			return false
		curr_number = card.number
	return true

static func compute_chain(cards: Array[CardData], enemy: EnemyData, state: GameState) -> StackResults:
	var result = StackResults.new()

	for i in range(cards.size()-1,-1,-1):
		var card = cards[i]
		for upgrade in card.upgrades:
			upgrade.first_pass.call(result, enemy, state, cards)

	for i in range(cards.size()-1,-1,-1):
		var card = cards[i]
		for upgrade in card.upgrades:
			upgrade.second_pass.call(result, enemy, state, cards)
	return result
