extends Node2D
var walking1: bool = false
@onready var jules = $jules


const DialogueResources = preload("res://DialogDocs/DialogWithWitch.dialogue")
const BALLOON_SCENE = preload("res://scenes/balloon.tscn")

func _ready() -> void:
	var balloon = BALLOON_SCENE.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(DialogueResources, "start")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if jules.position != Vector2(0, 0) and jules.position != Vector2(300, 0) and jules.position != Vector2(437.0, -18.0)  :
		#print("walking")
		walking1 = true
	else:
		walking1 = false
	walk()

func walk():
	if walking1 == true:
		print("walking")
		#var animation = "walking"
		#$Lea.update_animation(animation)
		$jules/AnimatedSprite2D.play("walking")
	else:
		$jules/AnimatedSprite2D.stop()
