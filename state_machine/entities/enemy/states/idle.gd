class_name Idle extends EnemyState

var idle_timer : Timer

func enter()-> void:
	enemy.velocity = Vector2.ZERO
	idle_timer = Timer.new()
	idle_timer.wait_time = randi_range(3,10)
	idle_timer.timeout.connect(_on_timeout)
	idle_timer.autostart = true
	add_child(idle_timer)

func _on_timeout() -> void:
	transition_requested.emit(self, State.WANDER)

func _physics_process(delta: float) -> void:
	pass
	#try_chase()

func exit()-> void:
	idle_timer.stop()
	idle_timer.timeout.disconnect(_on_timeout)
	idle_timer.queue_free()
	idle_timer = null
