class_name Deck extends Node2D

var data: DeckData:
	set(value):
		data = value
		_on_data_set()
@onready var main = get_parent()

func _on_data_set():
	data.card_appended.connect(_on_appended)
	data.card_removed.connect(_on_pop)

func _on_appended(card_data: CardData) -> void:
	var card = main.lookup_card(card_data)
	var old_position = card.global_position
	if card.get_parent():
		card.get_parent().remove_child(card)
	add_child(card)
	var to_pos = Vector2(0,0)
	if old_position == Vector2.ZERO:
		card.position = to_pos
	else:
		card.position = to_local(old_position)
		var tween: Tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(card, "position", to_pos, 0.25)
		AnimThread.make_blocking_anim_tween(tween)


func _on_pop(card_data: CardData):
	var card = main.lookup_card(card_data)
	var old_pos = card.global_position
	remove_child(card)
	card.global_position = old_pos
	return card
