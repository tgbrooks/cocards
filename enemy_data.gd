class_name EnemyData extends Resource

@export var enemy_name: String = "myenemy"
@export var attack: int = 0
@export var health: int = 1
@export var action_points_threshold: int = 3
@export var action_points: int = 0
@export var current_dodge: int = 0

signal defeated()
signal damaged(damage: int)
signal action_points_changed(old: int, new:int)
signal action_taken()
signal dodge_changed(old: int, new:int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func take_damage(damage: int) -> void:
	health -= damage
	damaged.emit(damage)
	if health <= 0:
		health = 0
		defeated.emit()

func take_action(state: GameState) -> void:
	var final_attack = max(attack - current_dodge, 0)
	var old_dodge = current_dodge
	current_dodge = 0
	dodge_changed.emit(old_dodge, current_dodge)
	state.damage_player(final_attack)
	action_taken.emit()

func gain_dodge(new_dodge: int) -> void:
	var old = current_dodge
	current_dodge += new_dodge
	dodge_changed.emit(old, current_dodge)
