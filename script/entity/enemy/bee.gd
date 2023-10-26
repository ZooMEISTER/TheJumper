extends CharacterBody2D

enum BEE_STATE {FLY, ATTACK, DIE}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2

# Get character AnimationPlayer
var animationPlayer

# Bee sensor area
var bee_Sensor_Area

# Bee origin position
var bee_Origin_Position
# Bee attack target player position
var bee_attack_target_position

# Bee attack speed
@export var bee_Attack_Speed = 200
# Bee sensor bodies
var bodies
# If bee die
@export var bee_Health:float = 25
var bee_Die_Timer_Node

func _ready():
	animationPlayer = get_node("AnimationPlayer")
	bee_Sensor_Area = get_node("Sensor")
	
	bee_Origin_Position = global_position
	
	bee_Die_Timer_Node = get_node("BeeDieTimer")
	
# Bee is dead
func Bee_Die(delta):
	velocity.y += gravity * delta
	
	if(get_node("Hitbox") != null):
		get_node("Hitbox").queue_free()
		get_node("Hurtbox").queue_free()
		get_node("Sensor").queue_free()
		
		velocity.x = 0
		velocity.y = -400
		
	move_and_slide()
	
	
func tick_physics(state, delta):
	if bee_Health <= 0:
		Bee_Die(delta)
	else:
		# Handle movement
		if state == BEE_STATE.FLY:
			if bee_Origin_Position.x > global_position.x:
				get_node("Sprite2D").scale.x = -1
			else:
				get_node("Sprite2D").scale.x = 1
				
			velocity = velocity.move_toward(bee_Origin_Position - global_position, delta * bee_Attack_Speed)
		elif state == BEE_STATE.ATTACK:
			if bodies[0].global_position.x > global_position.x:
				get_node("Sprite2D").scale.x = -1
			else:
				get_node("Sprite2D").scale.x = 1
				
			var direction = global_position.direction_to(bodies[0].global_position)
			velocity = velocity.move_toward(direction * bee_Attack_Speed, delta * bee_Attack_Speed)
		
		move_and_slide()

# Boar state mechine get_next_state()
# Handle the next state should choose
func get_next_state(state: BEE_STATE):
	if bee_Sensor_Area != null:
		bodies = bee_Sensor_Area.get_overlapping_bodies()
	else:
		return state
	
	match state:
		BEE_STATE.FLY:
			if bee_Health <= 0:
				return BEE_STATE.DIE
				
			if not bodies.is_empty():
				return BEE_STATE.ATTACK
				
			
		BEE_STATE.ATTACK:
			if bee_Health <= 0:
				return BEE_STATE.DIE
				
			if bodies.is_empty():
				return BEE_STATE.FLY
			else:
				bee_attack_target_position = bodies[0].global_position
				
		BEE_STATE.DIE:
			pass
			
	return state

# Boar state mechine transition_state()
# Handle the animation and part of actual movement
func transition_state(from: BEE_STATE, to: BEE_STATE):
	
	match to:
		BEE_STATE.FLY:
			animationPlayer.play("Fly")
			
		BEE_STATE.ATTACK:
			animationPlayer.play("Attack")
			
		BEE_STATE.DIE:
			animationPlayer.play("Die")
			bee_Die_Timer_Node.start()


func _on_bee_die_timer_timeout():
	queue_free()


func _on_hitbox_hit(hurtbox):
	if hurtbox.owner.is_in_group("Player"):
		bee_Health = 0


func _on_hurtbox_hurt(hitbox):
	if hitbox.owner.is_in_group("Player"):
		# Kill this boar
		bee_Health -= 50
