extends Area2D

@export var rootScene_NodePath:NodePath
@export var player_NodePath:NodePath

var root_Scene
var player

# Zombie movement param
@export var moveSpeed:float
@export var moveDir:Vector2

var startPosition:Vector2
var targetPosition:Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	root_Scene = get_node(rootScene_NodePath)
	player = get_node(player_NodePath)
	
	startPosition = global_position
	targetPosition = startPosition + moveDir
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Handle zombie movement
	global_position = global_position.move_toward(targetPosition, delta * moveSpeed)
	
	# Adjust zombie move start and end
	if global_position == targetPosition:
		if global_position == startPosition:
			targetPosition = startPosition + moveDir
		else:
			targetPosition = startPosition
		
		# Correct zombie move animation
		if targetPosition.x > global_position.x:
			get_node("Sprite2D").scale.x = 1
		else:
			get_node("Sprite2D").scale.x = -1

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player.Reset_Character_Position()
		player.Player_Life_Minus_One()
