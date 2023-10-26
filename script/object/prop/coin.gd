extends Area2D

@export var rootScene_NodePath:NodePath
var rootScene_Node

# Called when the node enters the scene tree for the first time.
func _ready():
	rootScene_Node = get_node(rootScene_NodePath)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Player collect coin
func _on_body_entered(body):
	if body.is_in_group("Player"):
		rootScene_Node.Player_Collect_One_Coin(self)
