class_name Util extends Node

static func suit_to_color(suit: Enums.Suit) -> Color:
	if suit == Enums.Suit.RED:
		return Color(0.9, 0.2, 0.2)
	elif suit == Enums.Suit.GREEN:
		return Color(0.2, 0.7, 0.2)
	elif suit == Enums.Suit.BLUE:
		return Color(0.2, 0.2, 0.8)
	else:
		assert(false,	 "invalid suit")
		return Color.MAGENTA
