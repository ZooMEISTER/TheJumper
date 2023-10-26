extends CanvasLayer

var isGamePaused:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if isGamePaused:
		self.visible = true
	else:
		self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		
	# Pause the game
	if Input.is_action_just_pressed("Pause"):
		if isGamePaused:
			get_tree().paused = false
			isGamePaused = false
			self.visible = false
		else:
			get_tree().paused = true
			isGamePaused = true
			self.visible = true


func _on_resume_button_pressed():
	get_tree().paused = false
	isGamePaused = false
	self.visible = false



func _on_main_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
