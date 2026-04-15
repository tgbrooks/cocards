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
	assert(blocking_anim_count >= 0, "blocking_anim_count is now negative!")
	if blocking_anim_count == 0:
		anim_done.emit()

func await_anim_okay():
	if blocking_anim_count == 0:
		return
	else:
		await anim_done
