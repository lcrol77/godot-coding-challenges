class_name StateMachine extends Node

@export var initial_state: EnemyState

var current_state: EnemyState
var states: Dictionary = {}

func init() -> void:
	var children = get_children()
	for child in children:
		if child is EnemyState:
			states[child.state] = child
			child.transition_requested.connect(_on_transition_requested)
	if initial_state:
		current_state = initial_state
		current_state.enter()

# When the state is active, this is essentially the _process() function
func process_state(delta: float):
	if current_state:
		current_state.process_state(delta)

# When the state is active, this is essentially the _physics_process() function
func physics_process_state(delta: float):
	if current_state:
		current_state.physics_process_state(delta)

func _on_transition_requested(from: EnemyState, to: EnemyState.State)-> void:
	print("transitioning from ", EnemyState.State.keys()[from.state], " to ", EnemyState.State.keys()[to])
	if from != current_state:
		return
	var new_state: EnemyState = states[to]
	if not new_state:
		return
	if current_state:
		current_state.exit()
	new_state.enter()
	current_state = new_state
