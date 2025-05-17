class_name EnemyState extends Node

enum State {
	IDLE,
	WANDER,
	CHASE,
	ATTACK,
}

signal transition_requested(from: EnemyState, to: EnemyState.State)
@onready var enemy: Enemy = get_owner()
@export var state: State
var player : Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

# This is called directly when transitioning to this state
# Useful for setting up the state to be used
# In Idle, we use this function to decide how long we will idle for
func enter():
	pass


# When the state is active, this is essentially the _process() function
func process_state(delta: float):
	pass


# When the state is active, this is essentially the _physics_process() function
func physics_process_state(delta: float):
	pass


# Useful for cleaning up the state
# For example, clearing any timers, disconnecting any signals, etc.
func exit():
	pass


#region util methods
func try_chase() -> bool:
	if player.global_position.distance_to(enemy.global_position) <= enemy.detection_radius:
		#transition_requested.emit(self, State.CHASE) TODO: reenable me when the chase state is implemented
		return true
	return false
#endregion
