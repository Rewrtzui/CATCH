extends Node2D


@onready var music_player = $SoundForWalkingAround
var chase_music = preload("res://assets/Audio/Music/FREE MUSIC PACK- Aila Scott/02-It's a Fight.wav")
var chill_music = preload("res://assets/Audio/Music/FREE MUSIC PACK- Aila Scott/05- Make it Work!.wav")

var is_in_field = false
# Zähler für fliehende Katzen
var cats_fleeing_count: int = 0




func _ready() -> void:
	Scenefade.fade_in()
	for child in $"Areas/interacteable Areas".get_children():
		if child.has_signal("interactedObj"):
			child.interactedObj.connect(_getting_obj)
	
	Global.place = "outside"
	Global.register_current_level(self)
	$NavigationRegion2D/objects/Lea.position = Global.player_current_position
	$NavigationRegion2D/objects/Lea.global_position = Global.player_current_position
	
	music_player.stream = chill_music
	music_player.play()



func cat_started_fleeing():
	
	if cats_fleeing_count == 0:
		#print("Music: Switch to Chase Theme")
		music_player.stream = chase_music
		music_player.play()
	
	# ...dann den Zähler erhöhen
	cats_fleeing_count += 1
	#print("Katzen auf der Flucht: ", cats_fleeing_count)

func cat_stopped_fleeing():
	cats_fleeing_count -= 1
	
	
	if cats_fleeing_count < 0:
		cats_fleeing_count = 0
	
	if cats_fleeing_count == 0:
		#print("Music: Back to Chill Theme")
		music_player.stream = chill_music
		music_player.play()
		
	#print("Katzen auf der Flucht: ", cats_fleeing_count)
	
	
	
	
#code für Katzensound -> button justpressed -> sends signal to all cat scripts und dann spielen diese den sound ab
#muss dafür die musik aus machen und sound von spielerin abspielen und dann wieder musik an machen


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		is_in_field = true
		Global.place = "feld"



func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		is_in_field = false
		Global.place = "outside"
		
func _getting_obj(specificObj):
	print(specificObj)
