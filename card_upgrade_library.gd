class_name CardUpgradeLibrary extends Node

static func has_twins(cs: Array[CardData]) -> bool:
	var twins = 0
	for card in cs:
		if card.card_labels.find('twin') >= 0:
			twins += 1
	return twins == 2

static func make_card_upgrade(name: String) -> CardUpgradeData:
	var upgrade: CardUpgradeData = CardUpgradeData.new()
	if name == "damage":
		upgrade.description = "⚔️"
		upgrade.damage = 1
	elif name == "shield":
		upgrade.description = "🛡️"
		upgrade.shield = 1
	elif name == "dodge":
		upgrade.description = "🏃"
		upgrade.dodge = 1
	elif name == "double_damage":
		upgrade.description = "double ⚔️"
		upgrade.second_pass = func(result, enemy, main, cards):
			result.damage *= 2
	elif name == "chain_damage":
		upgrade.description = "+⚔️ for card in stack"
		upgrade.first_pass = func(result, enemy, main, cards):
			result.damage += cards.size()
	elif name == "twin_damage":
		upgrade.description = "+2⚔️ if two twins in stack"
		upgrade.labels = ["twin"]
		upgrade.first_pass = func(result, enemy, main, cards):
			if has_twins(cards):
				result.damage += 2
	elif name == "twin_shield":
		upgrade.description = "+2🛡️ if two twins in stack"
		upgrade.labels = ["twin"]
		upgrade.first_pass = func(result, enemy, main, cards):
			if has_twins(cards):
				result.shield += 2
	elif name == "twin_dodge":
		upgrade.description = "+2🏃 if two twins in stack"
		upgrade.labels = ["twin"]
		upgrade.first_pass = func(result, enemy, main, cards):
			if has_twins(cards):
				result.dodge += 2
	else:
		print("Unknown card upgrade ", name)
	return upgrade
