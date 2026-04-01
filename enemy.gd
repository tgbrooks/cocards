class_name Enemy extends Button

@export var data: EnemyData

@onready var action_points_label: Label = $ActionPointsLabel
@onready var dodge_label: Label = $DodgeLabel
signal on_hover()
signal off_hover()

func _init(enemy_data: EnemyData):
	data = enemy_data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draw()
	data.defeated.connect(_on_defeated)
	data.action_points_changed.connect(_draw_action_points)
	_draw_action_points(0,0)
	data.dodge_changed.connect(_draw_dodge)
	mouse_entered.connect(on_hover.emit)
	mouse_exited.connect(off_hover.emit)
	data.damaged.connect(draw)
	data.action_taken.connect(_on_action_taken)

func draw():
	text = "%s\n%s/%s" % [data.enemy_name, data.attack, data.health]


func _on_defeated() -> void:
	print("Defeated a ", data.enemy_name)

	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0,0), 1.25)
	tween.tween_callback(self.queue_free)

func _on_action_taken(main: Main) -> void:
	# Animate the attack
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", 30, 0.15/2)
	tween.tween_property(self, "rotation_degrees", -30, 0.15)
	tween.tween_property(self, "rotation_degrees", 0, 0.15/2)
	#tween.tween_property(self, "scale", Vector2(1, 1), 0.15)
	await tween.finished


func _draw_action_points(old: int, new:int) -> void:
	var ns = "🔳".repeat(new)
	var empty
	if (data.action_points_threshold - new > 0):
		empty = "🔲".repeat(data.action_points_threshold - new)
	else:
		empty = ""
	action_points_label.text = "%s%s" % [ns, empty]

func _draw_dodge(old: int, new: int) -> void:
	var dodge_str = '🏃'.repeat(new)
	dodge_label.text = dodge_str
