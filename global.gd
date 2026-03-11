extends Node
signal Psps
"""
muss lea tscn noch coffee hinzufügen,

making all pixels the same size in the menu?
"""



var player_current_position: Vector2
var last_caught_cat_id: int = -1
var met_witch: bool = false
var met_cat_2: bool = false
var got_shovel: bool = false
var hole_closed: bool = false

var spawn_marker_name: String = ""
var place: String = "" #muss angepasst werden
var current_level_node: Node = null
var is_sneaking: bool = false
var number_of_cats_caught:int = 0  #muss null sein zu beginn
var dialogue_over_1: bool = false
var number_of_cups: int = 3
var blackscreen: bool = false
var said_schleimer: bool = false
var diashow: bool = false
var player_current_health: int = 100
var player_max_health: int = 100
var extra_heart: bool = false
var pause_menu = false
func _ready() -> void:
	pass
	#print(current_level_node)
	
	#Engine.max_fps = 60
	

func _process(_delta: float) -> void:
	#print(Engine.get_frames_per_second())
	#print(Engine.max_fps)
	#print(player_current_health)
	#print(number_of_cats_caught)
	#print(place)
	
	dying()
func register_current_level(level_node: Node):
	current_level_node = level_node
	#print("Neues Level registriert: ", current_level_node.name)

signal cat_status_changed(cat_id, is_found)

# Hier speichern wir den Status. ID (Zahl) -> Gefunden? (Bool)
var cats_found_state = {
	1: false,
	2: false,
	3: false,
	4: false,
	5: false,
}

func register_cat_found(cat_id: int):
	
	
	
	if cat_id in cats_found_state:
		cats_found_state[cat_id] = true
		#print("Global: Katze Nummer " + str(cat_id) + " wurde registriert!")
		last_caught_cat_id = cat_id
		number_of_cats_caught += 1
		cat_status_changed.emit(cat_id, true)
		print(number_of_cats_caught)
		call_deferred("change_to_dialoge")
	else:
		pass
		#print("Fehler: Katze ID " + str(cat_id) + " existiert nicht im Global State.")
		
		

	



func change_to_dialoge():
	await Scenefade.fade_out()
	get_tree().change_scene_to_file("res://scenes/talking_with_cats.tscn")


func taking_cat():
	$takingcat.play()

func reset_all_cats():
	for id in cats_found_state:
		cats_found_state[id] = false
	
	number_of_cats_caught = 0
	last_caught_cat_id = -1
	
func hurt_player(amount: int):
	$hurt.play()
	player_current_health -= amount
	print("Leben reduziert um ", amount, ". Rest: ", player_current_health)

func dying():
	if player_current_health <= 0:
		player_current_health += 1
		await Scenefade.fade_out()
		get_tree().change_scene_to_file("res://scenes/deathscreen.tscn")
func heal_player(amount: int):
	if player_current_health != 100:
		$heal.play()
		player_current_health += amount
		
		if player_current_health > player_max_health:
			player_current_health = player_max_health
		print("Healed:", amount, "Health:", player_current_health)
