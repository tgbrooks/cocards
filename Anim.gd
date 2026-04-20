extends Node
# autoload as AnimThread

var blocking_anim_count: int = 0
signal anim_done

func make_blocking_anim_tween(tween: Tween):
	start_blocking_anim()
	tween.tween_callback(func(): release_blocking_anim())
	

func start_blocking_anim():
	blocking_anim_count += 1

func release_blocking_anim():
	blocking_anim_count -= 1
	# Negative values can happen when we force reload the scene for debugging purposes
	if blocking_anim_count <= 0:
		anim_done.emit()
		blocking_anim_count

func await_anim_okay():
	while blocking_anim_count > 0:
		await anim_done

func wipe_anim_lock():
	blocking_anim_count = 0
	anim_done.emit()
