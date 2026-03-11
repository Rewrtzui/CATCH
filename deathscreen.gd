extends Node

func _ready() -> void:
	pass
	
	
	



func _on_give_up_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menü.tscn")


func _on_try_again_pressed() -> void:
	Global.reset_all_cats()
	Global.player_current_health = 100
	Global.number_of_cups = 3
	Global.player_current_position= Vector2(0,0)
	print("Try again")
	get_tree().change_scene_to_file("res://scenes/house_outside.tscn")
	#loading safe file
