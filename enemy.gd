class_name Enemy extends Button

@export var enemy_name: String = "myenemy"
@export var attack: int = 0
@export var health: int = 1
@export var action_points_threshold: int = 3
@export var action_points: int = 0
var current_dodge: int = 0
signal defeated()
signal survived()
signal damaged(damage: int)
signal action_points_changed(old: int, new:int)
signal action_taken()
signal dodge_changed(old: int, new:int)
@onready var action_points_label: Label = $ActionPointsLabel
@onready var dodge_label: Label = $DodgeLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draw()
	defeated.connect(_on_defeated)
	action_points_changed.connect(_draw_action_points)
	_draw_action_points(0,0)
	dodge_changed.connect(_draw_dodge)

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
	var final_attack = max(attack - current_dodge, 0)
	var old_dodge = current_dodge
	current_dodge = 0
	dodge_changed.emit(old_dodge, current_dodge)
	main.damage_player(final_attack)
	# Animate the attack
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", 30, 0.15/2)
	tween.tween_property(self, "rotation_degrees", -30, 0.15)
	tween.tween_property(self, "rotation_degrees", 0, 0.15/2)
	#tween.tween_property(self, "scale", Vector2(1, 1), 0.15)
	await tween.finished
	action_taken.emit()

func gain_dodge(new_dodge: int) -> void:
	var old = current_dodge
	current_dodge += new_dodge
	dodge_changed.emit(old, current_dodge)

func _draw_action_points(old: int, new:int) -> void:
	var ns = "🔳".repeat(new)
	var empty
	if (action_points_threshold - new > 0):
		empty = "🔲".repeat(action_points_threshold - new)
	else:
		empty = ""
	action_points_label.text = "%s%s" % [ns, empty]

func _draw_dodge(old: int, new_int) -> void:
	var dodge_str = '🏃'.repeat(current_dodge)
	dodge_label.text = dodge_str
