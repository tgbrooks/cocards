class_name Card extends Node2D

@export var data: CardData

@onready var card_face: Node2D = $CardFace
@onready var button: Button = $Button
@onready var number_label: Label = $CardFace/NumberLabel
@onready var name_label: Label = $CardFace/NameLabel
@onready var description_label: Label = $CardFace/DescriptionLabel
@onready var card_sprite: Sprite2D = $CardFace/CardSprite
@onready var preview: Node2D = $Preview
@onready var card_back_sprite: Sprite2D = $CardBackSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	number_label.text = "%s" % data.number
	name_label.text = data.card_name
	card_sprite.modulate = Util.suit_to_color(data.suit)
	var descriptions = []
	for upgrade in data.upgrades:
		descriptions.append(upgrade.description)
	description_label.text = ' '.join(descriptions)
	button.pressed.connect(_on_pressed)

	button.mouse_entered.connect(_on_hover)
	button.mouse_exited.connect(_off_hover)

	# Set-up the on-hover preview
#	preview.position = Vector2(card_sprite.texture.get_width() + 10, -10)
	preview.add_child(card_sprite.duplicate(false))
	preview.add_child(number_label.duplicate(false))
	preview.add_child(description_label.duplicate(false))
	
	data.card_flipped.connect(_on_card_flipped)

func _process(_delta: float) -> void:
	# Keep the card preview visible on screen
	var wsize: Vector2 = get_window().size
	var global_loc = global_position.y
	var size = card_sprite.get_rect().size.y * card_sprite.scale.y * preview.scale.y
	var preview_offset = -20
	preview.position.y = min(preview_offset, wsize.y - size - global_loc)

func _on_pressed() -> void:
	var parent = get_parent()
	if is_instance_of(parent, CardStack):
		parent.card_pressed(self)

func select() -> void:
	scale = Vector2(1.2, 1.2)
	
func unselect() -> void:
	scale = Vector2(1.0, 1.0)
	
func _on_card_flipped(face: Enums.CardFace) -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.0, 1.), 0.25)
	if face == Enums.CardFace.BACK:
		tween.tween_callback(func (): card_back_sprite.visible = true; card_face.visible=false)
		_off_hover()
	else:
		tween.tween_callback(func (): card_back_sprite.visible = false; card_face.visible =  true)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.25)
	await tween.finished

func _on_hover():
	if data.visible_face == Enums.CardFace.FRONT:
		# Pop up a bigger version
		preview.visible = true

func _off_hover():
	preview.visible = false

static func can_chain(cards: Array[Card]) -> bool:
	var card_datas: Array[CardData] = []
	for card in cards:
		card_datas.append(card.data)
	return CardData.can_chain(card_datas)

static func compute_chain(cards: Array[Card], enemy: Enemy, state: GameState) -> StackResults:
	var card_datas = []
	for card in cards:
		card_datas.append(card.data)
	return CardData.compute_chain(card_datas, enemy.data, state)
