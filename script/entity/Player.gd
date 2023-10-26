extends CharacterBody2D

enum PLAYER_STATE {IDLE, RUN, JUMP, FALL, ATTACK_1, ATTACK_2}

# Character param
const SPEED = 400.0
const JUMP_VELOCITY = -1000.0


# If player can combo attack
@export var can_Combo:bool = false
# If player have combo
var is_Combe_Allowed = false


# Player Life Count
@export var player_Life_Count:int = 5
@export var player_Health:float = 100
var player_Life_Total

# Game window size
var screen_Size

# Get character AnimationPlayer
var animationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2

func _ready():
	animationPlayer = get_node("AnimationPlayer")
	player_Life_Total = player_Life_Count

func tick_physics(state, delta):

	if player_Health <= 0:
		Player_Life_Minus_One()
		Reset_Character_Position()

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()


# Reset character position (drop out of the map/get killed)
func Reset_Character_Position():
	var spawn_posotion = Vector2(40, 500)
	self.position = spawn_posotion
	velocity = Vector2(0,0)

# Player got hit
func Player_Get_Attacked(damage: float, byNode):
	player_Health -= damage
	if byNode.global_position.x >= global_position.x:
		# Attacked from left
		velocity.y = -damage * 16
		velocity.x = -damage * 8
		
	elif byNode.global_position.x < global_position.x:
		# Attacked from right
		velocity.y = -damage * 16
		velocity.x = damage * 8
		
	move_and_slide()
	
# Player get killed
func Player_Life_Minus_One():
	player_Life_Count -= 1
	
	player_Health = 100
	
	# Game over
	# Jump to another scene
	if player_Life_Count <= 0:
		print("Game Over !!")
		player_Life_Count = player_Life_Total
		
		get_tree().paused = true
		self.owner.Game_Lose()
		
	

# Player state mechine get_next_state()
# Handle the next state should choose
func get_next_state(state: PLAYER_STATE):
	
	var move_direction = 0 - Input.get_action_strength("MoveLeft") + Input.get_action_strength("MoveRight")
	
	if Input.is_action_just_pressed("MoveJump") and is_on_floor():
		return PLAYER_STATE.JUMP
	
	match state:
		PLAYER_STATE.IDLE:
			if not is_on_floor():
				return PLAYER_STATE.FALL
			if move_direction != 0 && is_on_floor():
				return PLAYER_STATE.RUN
			
			if Input.is_action_just_pressed("Attack"):
				return PLAYER_STATE.ATTACK_1
			
		PLAYER_STATE.RUN:
			if not is_on_floor():
				return PLAYER_STATE.FALL
			if move_direction == 0 && is_on_floor():
				return PLAYER_STATE.IDLE
				
			if Input.is_action_just_pressed("Attack"):
				return PLAYER_STATE.ATTACK_1
			
		PLAYER_STATE.JUMP:
			if velocity.y > 0:
				return PLAYER_STATE.FALL
				
			if Input.is_action_just_pressed("Attack"):
				return PLAYER_STATE.ATTACK_1
			
		PLAYER_STATE.FALL:
			if is_on_floor():
				return PLAYER_STATE.IDLE
				
			if Input.is_action_just_pressed("Attack"):
				return PLAYER_STATE.ATTACK_1
			
		PLAYER_STATE.ATTACK_1:
			# Check if player can combo
			if animationPlayer.is_playing() && can_Combo && Input.is_action_just_pressed("Attack"):
				is_Combe_Allowed = true
				
			if is_on_floor():
				velocity.x = 0
			
			# Attack_1 end
			if not animationPlayer.is_playing():
				if is_Combe_Allowed:
					return PLAYER_STATE.ATTACK_2
				else:
					if is_on_floor():
						return PLAYER_STATE.IDLE
					elif velocity.y >= 0:
						return PLAYER_STATE.FALL
					elif velocity.y < 0:
						return PLAYER_STATE.JUMP
						
						
		PLAYER_STATE.ATTACK_2:
			is_Combe_Allowed = false
			
			if is_on_floor():
				velocity.x = 0
			
			if not animationPlayer.is_playing():
				if is_on_floor():
					return PLAYER_STATE.IDLE
				elif velocity.y >= 0:
					return PLAYER_STATE.FALL
				elif velocity.y < 0:
					return PLAYER_STATE.JUMP
			
	
	return state

# Player state mechine transition_state()
# Handle the animation and actual movement
func transition_state(from: PLAYER_STATE, to: PLAYER_STATE):
	var move_direction = 0 - Input.get_action_strength("MoveLeft") + Input.get_action_strength("MoveRight")
	
	match to:
		PLAYER_STATE.IDLE:
			velocity.x = 0
			animationPlayer.play("Idle")
			
		PLAYER_STATE.RUN:
			# Correct character face direction
			if(move_direction > 0):
				get_node("Sprite2D").scale.x = 1
				get_node("Hitbox").scale.x = 1
			elif(move_direction < 0):
				get_node("Sprite2D").scale.x = -1
				get_node("Hitbox").scale.x = -1
				
			# Set walk velocity
			velocity.x = move_direction * SPEED
			
			animationPlayer.play("Run")
			
		PLAYER_STATE.JUMP:
			velocity.y = JUMP_VELOCITY
			
			animationPlayer.play("Jump")
			
		PLAYER_STATE.FALL:
			animationPlayer.play("Fall")
			
		PLAYER_STATE.ATTACK_1:
			animationPlayer.play("Attack_1")
		
		PLAYER_STATE.ATTACK_2:
			animationPlayer.play("Attack_2")
			
	
	move_and_slide()


func _on_hurtbox_hurt(hitbox):
	if(hitbox.owner.is_in_group("Boar")):
		# print(hitbox.owner)
		Player_Get_Attacked(25, hitbox.owner)
	elif(hitbox.owner.is_in_group("Bee")):
		# print(hitbox.owner)
		Player_Get_Attacked(50, hitbox.owner)
