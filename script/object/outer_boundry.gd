extends Area2D

@export var rootScene_NodePath:NodePath
@export var player_NodePath:NodePath

var root_Scene
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	root_Scene = get_node(rootScene_NodePath)
	player = get_node(player_NodePath)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("Player"):
		player.Reset_Character_Position()
		player.Player_Life_Minus_One()
