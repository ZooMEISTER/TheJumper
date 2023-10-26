extends CharacterBody2D

enum BOAR_STATE {IDLE, WALK, RUN, DIE}

# Boar movement param
@export var moveSpeed:float
@export var moveDir:Vector2
@export var runMultiplier:float = 1.5

var startPosition:Vector2
var endPosition:Vector2
var targetPosition:Vector2

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2

# Get character AnimationPlayer
var animationPlayer
# Get boar raycast2d
var RayCast2D_Left:RayCast2D
var RayCast2D_Right:RayCast2D

# Boar health
@export var boar_Health:float = 25
# If bee die
var boar_Die_Timer_Node

func _ready():
	animationPlayer = get_node("AnimationPlayer")
	RayCast2D_Left = get_node("RayCast2D_Left")
	RayCast2D_Right = get_node("RayCast2D_Right")
	
	startPosition = global_position
	endPosition = startPosition + moveDir
	targetPosition = endPosition
	
	boar_Die_Timer_Node = get_node("BoarDieTimer")
	
func min(a, b):
	if a < b:
		return a
	return b
	
func max(a, b):
	if a < b:
		return b
	return a
	
func Boar_Die(delta):
	velocity.y += gravity * delta
	
	if get_node("Hitbox") != null:
		boar_Die_Timer_Node.start()
		get_node("Sprite2D").scale.y = -1
		animationPlayer.stop()
		
		get_node("Hitbox").queue_free()
		get_node("Hurtbox").queue_free()
		
		velocity.x = 0
		velocity.y = -400
		
	move_and_slide()
	
	
func tick_physics(state, delta):
	if(boar_Health <= 0):
		Boar_Die(delta)
	else:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
			
		# Handle RayCast2D
		var rayCastVector_Left = Vector2(min(startPosition.x, endPosition.x) - global_position.x, 0)
		var rayCastVector_Right = Vector2(max(startPosition.x, endPosition.x) - global_position.x, 0)
		RayCast2D_Left.set_target_position(rayCastVector_Left)	
		RayCast2D_Right.set_target_position(rayCastVector_Right)	
			
		# Handle movement
		if state == BOAR_STATE.WALK:
			if endPosition.x > startPosition.x:
				if global_position.x <= startPosition.x && targetPosition.x == startPosition.x:
					targetPosition = endPosition
				elif global_position.x >= endPosition.x && targetPosition.x == endPosition.x:
					targetPosition = startPosition
				elif targetPosition.x == endPosition.x:
					velocity.x = moveSpeed
					get_node("Sprite2D").scale.x = -1
				elif targetPosition.x == startPosition.x:
					velocity.x = -moveSpeed 
					get_node("Sprite2D").scale.x = 1
			elif endPosition.x < startPosition.x:
				if global_position.x >= startPosition.x && targetPosition.x == startPosition.x:
					targetPosition = endPosition
				elif global_position.x <= endPosition.x && targetPosition.x == endPosition.x:
					targetPosition = startPosition
				elif targetPosition.x == endPosition.x:
					velocity.x = -moveSpeed
					get_node("Sprite2D").scale.x = 1
				elif targetPosition.x == startPosition.x:
					velocity.x = moveSpeed
					get_node("Sprite2D").scale.x = -1
		elif state == BOAR_STATE.RUN:
			if RayCast2D_Left.get_collider() != null:
				velocity.x = -moveSpeed  * runMultiplier
				get_node("Sprite2D").scale.x = 1
			elif RayCast2D_Right.get_collider() != null:
				velocity.x = moveSpeed * runMultiplier
				get_node("Sprite2D").scale.x = -1
		
		move_and_slide()

# Boar state mechine get_next_state()
# Handle the next state should choose
func get_next_state(state: BOAR_STATE):
	
	match state:
		BOAR_STATE.IDLE:
			if moveSpeed != 0:
				return BOAR_STATE.WALK
			
		BOAR_STATE.WALK:
			# Check if ray detect player
			if RayCast2D_Left.get_collider() != null:
				if RayCast2D_Left.get_collider().is_in_group("Player"):
					return BOAR_STATE.RUN
			if RayCast2D_Right.get_collider() != null:
				if RayCast2D_Right.get_collider().is_in_group("Player"):
					return BOAR_STATE.RUN
#			
		BOAR_STATE.RUN:
			if RayCast2D_Left.get_collider() == null && RayCast2D_Right.get_collider() == null:
				return BOAR_STATE.WALK
			
			
	return state

# Boar state mechine transition_state()
# Handle the animation and part of actual movement
func transition_state(from: BOAR_STATE, to: BOAR_STATE):
	
	match to:
		BOAR_STATE.IDLE:
			velocity.x = 0
			animationPlayer.play("Idle")
			
		BOAR_STATE.WALK:
			animationPlayer.play("Walk")
			
		BOAR_STATE.RUN:
			animationPlayer.play("Run")
			
	
	move_and_slide()


func _on_hurtbox_hurt(hitbox):
	if hitbox.owner.is_in_group("Player"):
		# Kill this boar
		boar_Health -= 50


func _on_boar_die_timer_timeout():
	queue_free()
