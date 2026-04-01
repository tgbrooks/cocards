class_name DeckData extends Resource

var cards: Array[CardData] = []

signal card_appended(card: CardData)
signal card_removed(card: CardData)
signal shullfed()

func append(card: CardData) -> void:
	cards.append(card)
	card_appended.emit(card)

func pop() -> CardData:
	var card = cards.pop_back()
	if card:
		card_removed.emit(card)
	return card

func shuffle() -> void:
	cards.shuffle()
	shuffled.emit()
