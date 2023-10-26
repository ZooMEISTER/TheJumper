extends CanvasLayer

@export var rootScene_NodePath:NodePath
@export var player_NodePath:NodePath

var rootScene_Node
var player
var playerLifeCountNode
var playerHealthNode
var coinCountNode

# Called when the node enters the scene tree for the first time.
func _ready():
	rootScene_Node = get_node(rootScene_NodePath)
	player = get_node(player_NodePath)
	playerLifeCountNode = get_node("PlayerLifeCount")
	playerHealthNode = get_node("PlayerHealth")
	coinCountNode = get_node("CoinCount")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	playerLifeCountNode.set_text("Player Life Count: " + str(player.player_Life_Count))
	playerHealthNode.set_text("Player Health: " + str(player.player_Health))
	coinCountNode.set_text("Coin: " + str(rootScene_Node.coin_Collected) + "/" + str(rootScene_Node.coin_Collect_Target))
	
	if self.owner.game_state == 0:
		self.visible = true
	else:
		self.visible = false
