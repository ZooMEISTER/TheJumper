class_name StateMachine
extends Node

var current_State:int = -1:
	set(v):
		owner.transition_state(current_State, v)
		current_State = v

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	current_State = 0


func _physics_process(delta) -> void:
	while true:
		var next := owner.get_next_state(current_State) as int
		if current_State == next:
			break
		current_State = next
	
	owner.tick_physics(current_State, delta)
