extends Node2D
const DialogueResources1 = preload("res://DialogDocs/TalkingCats.dialogue")
const BALLOON_SCENE = preload("res://scenes/balloon.tscn")
var current_health: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.register_current_level(self)
	await Scenefade.fade_in()
	
	var balloon = BALLOON_SCENE.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(DialogueResources1, "start")
	
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	current_health = Global.player_current_health
	



func _on_dialogue_ended(resource: DialogueResource):
	if resource == DialogueResources1:
		
			await Scenefade.fade_out()
			get_tree().change_scene_to_file("res://scenes/house_outside.tscn")
	else:
			print("ende")
