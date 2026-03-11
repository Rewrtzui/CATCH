extends Node2D

func _ready() -> void:
	Scenefade.fade_in()
	Global.place = "outside"
	Global.register_current_level(self)
	
func _on_area_2d_body_entered(body) -> void:
	print(body)
	
	if body is CharacterBody2D:
		Global.spawn_marker_name = "SpawnPointDoor"
		
		print("exiting...")
		call_deferred("change_scene")
		
func change_scene():
	Scenefade.fade_out()
	await Scenefade.fade_complete
	get_tree().change_scene_to_file("res://scenes/house_outside.tscn")
	print("exited")
