extends Node2D
var interacted: bool = false
var player_near_by: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer.hide()
	$Lea.interact.connect(_on_interact)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	print(interacted)


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
		print("you pressed E")
		interacted = true
	else:
		interacted = false
