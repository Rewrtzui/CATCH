extends CharacterBody2D
@onready var player = get_tree().get_first_node_in_group("Player")
var interacted: bool = false
var player_near_by: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$CanvasLayer.hide()
	player.interact.connect(_on_interact)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#print(interacted)
	pass

func _on_interaction_area_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("Player"):
		print(body)
		$CanvasLayer.show()
		player_near_by = true
		
	


func _on_interaction_area_body_exited(_body: Node2D) -> void:
	$CanvasLayer.hide()
	player_near_by = false

func _on_interact():
	if player_near_by == true:
		print("talked")
		interacted = true
		get_tree().change_scene_to_file("res://scenes/dialog_scene.tscn")
	else:
		interacted = false
