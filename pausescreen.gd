extends CanvasLayer
"""

making visible which cats you already caught -> see name and being able to click on them to talk to them?
or just small thinks like small comments on mouse click

making buttons different stones of the wall or signs or something else, making it like horizontal?
or vertical and of kilter so left right left 

"""
@onready var main_menu: Control = $CenterContainer/PauseMenu
@onready var options_menu: Control = $CenterContainer/Options
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var cat1_player = $AnimPlayers/Cat1
@onready var cat2_player = $AnimPlayers/Cat2
@onready var cat3_player = $AnimPlayers/Cat3
@onready var cat4_player = $AnimPlayers/Cat4
@onready var cat5_player = $AnimPlayers/Cat5

var is_in_options = false


func _ready() -> void:
	#player.change_state(player.STATE.TALKING)
	$CenterContainer/Options/VolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	$CenterContainer/Options/Screensize.button_pressed = true if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN else false
	checking_cats()


func _process(_delta: float) -> void:
	pass


func _on_continue_pressed() -> void:
	Global.pause_menu = false
	queue_free()


func _on_options_pressed() -> void:
	is_in_options = true
	main_menu.visible = false
	options_menu.visible = true


func _on_back_to_menu_pressed() -> void:
	Global.pause_menu = false
	await Scenefade.fade_out()
	Scenefade.fade_in()
	get_tree().change_scene_to_file("res://scenes/menü.tscn")


func _on_screensize_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else: 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)


func _on_back_pressed() -> void:
	is_in_options = false
	main_menu.visible = true
	options_menu.visible = false
	
func checking_cats()-> void:
	for cat in Global.cats_found_state:
		var caught: bool = Global.cats_found_state[cat]
		if caught == true:
			setup_cat_visuals(cat)
		

func setup_cat_visuals(id: int) -> void:
	var skin_path = ""
	match id:
		1:
			skin_path = "res://Animations/cat_1_skin.tres" # .tres.tres korrigiert
		2:
			skin_path = "res://Animations/cat_2.tres"
		3:
			skin_path = "res://Animations/cat_3.tres"
		4:
			skin_path = "res://Animations/cat_4.tres"
		5:
			skin_path = "res://Animations/cat_5.tres"
		_:
			print("Kein Skin für ID gefunden: ", id)
			return         

	if ResourceLoader.exists(skin_path):
		var res = load(skin_path)
		if res is SpriteFrames:
			if id == 1:
				cat1_player.sprite_frames = res
				cat1_player.visible = true
				cat1_player.play("idle") 
				cat1_player.flip_h = true
			if id == 2:
				cat2_player.sprite_frames = res
				cat2_player.visible = true
				cat2_player.play("idle") 
				cat2_player.flip_h = true
			if id == 3:
				cat3_player.sprite_frames = res
				cat3_player.visible = true
				cat3_player.play("idle") 
				cat3_player.flip_h = true
			if id == 4:
				cat4_player.sprite_frames = res
				cat4_player.visible = true
				cat4_player.play("idle") 
				cat4_player.flip_h = true
			if id == 5:
				cat5_player.sprite_frames = res
				cat5_player.visible = true
				cat5_player.play("idle") 
				cat5_player.flip_h = true
			
				
			print("SpriteFrames geladen für ID ", id)
		else:
			print("Fehler: Datei gefunden, aber kein SpriteFrames-Typ: ", skin_path)
	else:
		print("Fehler: ResourceLoader findet Datei nicht: ", skin_path)
