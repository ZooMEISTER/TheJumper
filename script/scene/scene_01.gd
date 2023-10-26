extends Node2D

var screen_Size

# Level coin collect target and current count
var coin_Collect_Target
var coin_Collected

var level_Num = 1

# 0 for usual, 1 for lose, 2 for win
var game_state = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.max_fps = 60
	screen_Size = get_viewport_rect().size
	
	coin_Collect_Target = 5
	coin_Collected = 0
	
	get_node("lose_scene").visible = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
# Player collect 1 coin
func Player_Collect_One_Coin(coin):
	# Coin_Count plus 1
	coin_Collected += 1
	# Kill this coin
	print(coin)
	coin.queue_free()
	
# Check if player reach the coin collect goal
func Is_Coin_Enough() -> bool:
	return coin_Collected >= coin_Collect_Target

# Game Win
func Game_Win():
	game_state = 2
	
# Game Lose
func Game_Lose():
	game_state = 1
