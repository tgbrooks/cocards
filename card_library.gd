class_name CardLibrary extends Node
var card_scene = preload("res://card.tscn")

func make_card_by_name(card_name: String, main: Main) -> Card:
	var card = card_scene.instantiate()
	card.data = make_card_data_by_name(card_name, main)
	return card

func make_card_data_by_name(card_name: String, main: Main) -> CardData:
	var card = CardData.new()
	card.card_name = card_name
	if card_name == 'green one':
		card.number = 1
		card.suit = Enums.Suit.GREEN
		card.upgrades = [CardUpgradeLibrary.make_card_upgrade('dodge'), CardUpgradeLibrary.make_card_upgrade('dodge')]
	elif card_name == 'green two':
		card.number = 2
		card.suit = Enums.Suit.GREEN
		card.upgrades = [CardUpgradeLibrary.make_card_upgrade('dodge'), CardUpgradeLibrary.make_card_upgrade('dodge')]
	elif card_name == 'green three':
		card.number = 3
		card.suit = Enums.Suit.GREEN
		card.upgrades = [CardUpgradeLibrary.make_card_upgrade('dodge'), CardUpgradeLibrary.make_card_upgrade('dodge')]
	elif card_name == 'blue one':
		card.number = 1
		card.suit = Enums.Suit.BLUE
		card.upgrades = [CardUpgradeLibrary.make_card_upgrade('shield')]
	elif card_name == 'blue two':
		card.number = 2
		card.suit = Enums.Suit.BLUE
		card.upgrades = [CardUpgradeLibrary.make_card_upgrade('shield')]
	elif card_name == 'blue three':
		card.number = 3
		card.suit = Enums.Suit.BLUE
		card.upgrades = [CardUpgradeLibrary.make_card_upgrade('shield')]
	elif card_name == 'red one':
		card.number = 1
		card.suit = Enums.Suit.RED
		card.upgrades = [CardUpgradeLibrary.make_card_upgrade('damage')]
	elif card_name == 'red two':
		card.number = 2
		card.suit = Enums.Suit.RED
		card.upgrades = [CardUpgradeLibrary.make_card_upgrade('damage')]
	elif card_name == 'red three':
		card.number = 3
		card.suit = Enums.Suit.RED
		card.upgrades = [CardUpgradeLibrary.make_card_upgrade('damage')]
	elif card_name == 'chain':
		card.number = 1
		card.suit = Enums.Suit.RED
		card.upgrades = [CardUpgradeLibrary.make_card_upgrade("chain_damage")]
	elif card_name == 'red twin':
		card.number = 2
		card.suit = Enums.Suit.RED
		card.upgrades = [CardUpgradeLibrary.make_card_upgrade("twin_damage")]
	elif card_name == 'green twin':
		card.number = 3
		card.suit = Enums.Suit.GREEN
		card.upgrades = [CardUpgradeLibrary.make_card_upgrade("twin_dodge")]
	elif card_name == 'blue twin':
		card.number = 1
		card.suit = Enums.Suit.BLUE
		card.upgrades = [CardUpgradeLibrary.make_card_upgrade('twin_shield')]
	elif card_name == 'double_dmg':
		card.number = 1
		card.suit = Enums.Suit.RED
		card.upgrades = [CardUpgradeLibrary.make_card_upgrade('double_damage')]
	else:
		print("Unrecognized card name", card_name)
		return null
	return card
