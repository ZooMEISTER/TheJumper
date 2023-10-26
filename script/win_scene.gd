extends Node2D

var level_Num

# Called when the node enters the scene tree for the first time.
func _ready():
	level_Num = self.owner.level_Num
	print(level_Num)
	print(self.owner.game_state)
	
	get_node("CanvasLayer").visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.owner.game_state == 2:
		get_node("CanvasLayer").visible = true


func _on_next_level_pressed():
	pass # Replace with function body.

# Go to level select
func _on_level_select_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://level_select.tscn")
