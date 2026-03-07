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

static func format_heat(heat) -> String:
	return '🔥'.repeat(heat)
static func format_oil(oil) -> String:
	return '💧'.repeat(oil)
static func format_work(work) -> String:
	return '🔧'.repeat(work)
static func format_resources(heat, oil, work) -> String:
	var heats = format_heat(heat)
	var oils = format_oil(oil)
	var works = format_work(work)
	return "%s%s%s" % [heats, oils, works]
