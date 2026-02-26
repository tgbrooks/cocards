class_name Enemy extends Button

@export var enemy_name: String = "myenemy"
@export var attack: int = 0
@export var health: int = 1
signal defeated()
signal survived()
signal damaged(damage: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draw()
	defeated.connect(_on_defeated)

func draw():
	text = "%s\n%s/%s" % [enemy_name, attack, health]


func _on_defeated() -> void:
	print("Defeated a ", enemy_name)

func take_damage(damage: int) -> void:
	health -= damage
	damaged.emit(damage)
	if health <= 0:
		health = 0
		defeated.emit()
		#if get_parent():
		#	get_parent().remove_child(self)
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(0,0), 1.25)
		tween.tween_callback(self.queue_free)
	draw()

func take_action(main: Main) -> void:
	main.damage_player(attack)
	# Animate the attack
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", 30, 0.15)
	tween.tween_property(self, "rotation_degrees", -30, 0.15)
	tween.tween_property(self, "rotation_degrees", 0, 0.15/2)
	#tween.tween_property(self, "scale", Vector2(1, 1), 0.15)
	await tween.finished
