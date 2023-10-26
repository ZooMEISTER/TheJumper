extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("TextureRect/CenterContainer/VBoxContainer/HBoxContainer_02").visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_level_01_pressed():
	get_tree().change_scene_to_file("res://level/level_01.tscn")
