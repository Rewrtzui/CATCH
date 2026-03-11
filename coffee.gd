extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Global.number_of_cups != 3:
		if $Cooldown.is_stopped():
			$Cooldown.start()
			#print("iditot", Global.number_of_cups)
	if Global.number_of_cups == 2:
		$all/CUPS3/Cup1.visible = false
		$all/CUPS2/Cup1.visible = true
		$all/CUPS1/Cup1.visible = true
	if Global.number_of_cups == 1:
		$all/CUPS3/Cup1.visible = false
		$all/CUPS2/Cup1.visible = false
		$all/CUPS1/Cup1.visible = true
	if Global.number_of_cups == 0:
		$all/CUPS3/Cup1.visible = false
		$all/CUPS2/Cup1.visible = false
		$all/CUPS1/Cup1.visible = false
	if Global.number_of_cups == 3:
		
		$all/CUPS3/Cup1.visible = true
		$all/CUPS2/Cup1.visible = true
		$all/CUPS1/Cup1.visible = true




func _on_cooldown_timeout() -> void:
	if Global.number_of_cups < 3:
		Global.number_of_cups += 1
		$AudioStreamPlayer2D.play()
		#print(Global.number_of_cups)
