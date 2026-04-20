class_name DeckData extends Resource

var cards: Array[CardData] = []

signal card_appended(card: CardData)
signal card_removed(card: CardData)
signal shuffled()

func append(card: CardData) -> void:
	cards.append(card)
	card_appended.emit(card)
	await AnimThread.await_anim_okay()

func pop() -> CardData:
	var card = cards.pop_back()
	if card:
		card_removed.emit(card)
		await AnimThread.await_anim_okay()
	return card

func shuffle() -> void:
	cards.shuffle()
	shuffled.emit()
	await AnimThread.await_anim_okay()
