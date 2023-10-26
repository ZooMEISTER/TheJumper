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
	if self.owner.game_state == 1:
		get_node("CanvasLayer").visible = true


# Go to main menu
func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://level_select.tscn")


# Restart this level
func _on_restart_pressed():
	if level_Num == 1:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://level/level_01.tscn")
