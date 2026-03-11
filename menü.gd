extends Control
""" chnaging the t of  catch to a different color, 
playing around with seperation of buttons and font size,
what button design?,
timer verlängern da mehr space ist,
auf deutsch und english machen -> erstmal lernen

"""
@onready var title: Control = $TextureRect
@onready var main_menu: Control = $CenterContainer/Main
@onready var options_menu: Control = $CenterContainer/Options
@onready var credits: Control = $CenterContainer/Credits

var is_in_credits = false
var is_in_options = false
var last_mouse_pos = Vector2()

func _ready() -> void:
	$CenterContainer/Options/VolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	$CenterContainer/Options/Screensize.button_pressed = true if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN else false
	$ColorRect.visible = false
	$Forbidden/CollisionShape2D.set_deferred("disabled", true)
	main_menu.visible = false
	credits.visible = false
	
	$Timer.start()
	last_mouse_pos = get_viewport().get_mouse_position()
	

func _process(_delta: float) -> void:
	if $AudioStreamPlayer2D.playing == false:
		$AudioStreamPlayer2D.play()
	
	if not is_in_options:
		$CenterContainer/Options.visible = false
	
	var current_pos = get_viewport().get_mouse_position()
	
	if current_pos != last_mouse_pos:
		if not is_in_options and not is_in_credits :
			main_menu.visible = true
		if is_in_options:
			options_menu.visible = true
		if is_in_credits:
			credits.visible = true
		$Timer.start()
		
		last_mouse_pos = current_pos
	
	# If current_pos == last_mouse_pos:

func _on_timer_timeout() -> void:
	main_menu.visible = false
	options_menu.visible = false
	
func _on_start_button_pressed() -> void:
	await Scenefade.fade_out()
	$ColorRect.visible = true
	get_tree().change_scene_to_file("res://scenes/house_outside.tscn")

func _on_end_button_pressed() -> void:
	get_tree().quit()


func _on_forbidden_body_entered(body):
	print(body)


func _on_timerforwtich_timeout():
	$Forbidden/CollisionShape2D.set_deferred("disabled", false)


func _on_options_pressed():
	is_in_options = true
	main_menu.visible = false
	options_menu.visible = true





func _on_credits_pressed() -> void:
	is_in_credits = true
	main_menu.visible = false
	options_menu.visible = false
	credits.visible = true
	


func _on_back_pressed() -> void:
	is_in_options = false
	is_in_credits = false
	main_menu.visible = true
	options_menu.visible = false
	credits.visible = false


func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)
#später vllt noch music und sfx trennen, dabei neue buse erstellen 
#und genau so machen, nicht vergessen, bei den audiostreamern , die busse zu akutaliseiren

func _on_screensize_toggled(toggled_on: bool) -> void:

	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else: 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
