extends Node2D
const DialogueResources1 = preload("res://DialogDocs/TalkwithJules.dialogue")
const BALLOON_SCENE = preload("res://scenes/MainBallon.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.register_current_level(self)
	#1. Dialog starten
	$Lea/camera.zoom = Vector2(5, 5)
	$Lea/camera.offset = Vector2(25, -50)
	Global.current_level_node = $"."
	$Lea/Hearts.visible = false
	await Scenefade.fade_in()
	
	# Balloon erstellen (Hier noch den manuellen Weg, den du nutzt)
	var balloon = BALLOON_SCENE.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(DialogueResources1, "start")
	
	# 2. Verbinde das Signal "dialogue_ended" vom Manager
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
 
func _on_dialogue_ended(resource: DialogueResource):
	# WICHTIG: Trenne das Signal direkt nach dem Aufruf, 
	# damit es nicht mehrfach feuert, falls Dialoge geloopt werden.
	DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)
	
	if Global.said_schleimer == true: 
		await Scenefade.fade_out()
		get_tree().change_scene_to_file("res://scenes/diashow.tscn")
	else:
		# Optional: Ein kleiner Fade-Out vor dem Schließen sieht professioneller aus
		await Scenefade.fade_out()
		get_tree().quit()
