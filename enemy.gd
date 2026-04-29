class_name Enemy extends Node2D

@export var data: EnemyData

@onready var action_points_label: Label = $ActionPointsLabel
@onready var dodge_label: Label = $DodgeLabel
@onready var button: Button = $Button
signal on_hover()
signal off_hover()

var main: Main

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draw()
	data.defeated.connect(_on_defeated)
	data.action_points_changed.connect(_draw_action_points)
	_draw_action_points(0,0)
	data.dodge_changed.connect(_draw_dodge)
	button.mouse_entered.connect(on_hover.emit)
	button.mouse_exited.connect(off_hover.emit)
	data.damaged.connect(_on_damaged)
	data.action_taken.connect(_on_action_taken)

func _on_damaged(_damage: int):
	draw()

func draw():
	button.text = "%s\n%s/%s" % [data.enemy_name, data.attack, data.health]

func _on_defeated() -> void:
	print("Defeated a ", data.enemy_name)

	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0,0), 1.25)
	tween.tween_callback(self.queue_free)

func _on_action_taken() -> void:
	# Animate the attack
	await AnimThread.await_anim_okay()
	var tween = create_tween()
	var target_pos = main.player_position.lerp(global_position, 0.2) # go most of the way to the player
	tween.tween_property(button, "global_position", target_pos, 0.15)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(button, "global_position", global_position, 0.15)
	tween.set_ease(Tween.EASE_OUT)
	AnimThread.make_blocking_anim_tween(tween)
	await tween.finished

func _draw_action_points(_old: int, new:int) -> void:
	var ns = "🔳".repeat(new)
	var empty
	if (data.action_points_threshold - new > 0):
		empty = "🔲".repeat(data.action_points_threshold - new)
	else:
		empty = ""
	action_points_label.text = "%s%s" % [ns, empty]

func _draw_dodge(_old: int, new: int) -> void:
	var dodge_str = '🏃'.repeat(new)
	dodge_label.text = dodge_str
