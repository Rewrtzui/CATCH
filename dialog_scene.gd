extends Node2D

const DialogueResources1 = preload("res://DialogDocs/DialogWithWitch.dialogue")
const BALLOON_SCENE = preload("res://scenes/MainBallon.tscn")
@onready var grand_child = $Witch/InteractionArea

func _ready() -> void:
	var player = $Lea
	player.get_node("camera").enabled = false
	
	player.get_node("Hearts").visible = false
	Global.register_current_level(self)
	
	grand_child.visible = false
	$Lea/camera.zoom = Vector2(4, 4)
	$Lea/camera.offset = Vector2(25, -50)
	Global.current_level_node = $"."
	grand_child.visible = false
	await Scenefade.fade_in()
	
	)
	var balloon = BALLOON_SCENE.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(DialogueResources1, "start")

	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
func _process(_delta: float) -> void:
	#_black_screen()
	pass

func _on_dialogue_ended(resource: DialogueResource):
	
	if resource == DialogueResources1:
		if Global.number_of_cats_caught == 5:
			await Scenefade.fade_out()
			get_tree().change_scene_to_file("res://scenes/dialogue_scene_with_jules.tscn") 
		else:
			await Scenefade.fade_out()
			get_tree().change_scene_to_file("res://scenes/house_outside.tscn") 
		#make it go to the szene where the the pos is same to current and the cats have spawnt.
		#i also have to add more to the dialog-> like an explanation of what the cats can do and that maybe sneaking/going fast/or trapping it are advised

#func _black_screen():
	#if Global.blackscreen == true:
		#$ColorRect.visible = true
	#else:
		#$ColorRect.visible = false
