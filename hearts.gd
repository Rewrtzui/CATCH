extends CanvasLayer
var active = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	extra_heart()
	if Global.player_current_health == 150:
		$Node2D/Heart1/full1.visible = true
		$Node2D/Heart2/full2.visible = true
		$Node2D/Heart3/full.visible = true
		$Node2D/Heart4/full.visible = true
		$Node2D/Heart5/full.visible = false
	elif Global.player_current_health == 100:
		$Node2D/Heart1/full1.visible = true
		$Node2D/Heart2/full2.visible = true
		$Node2D/Heart3/full.visible = true
		$Node2D/Heart4/full.visible = true
		$Node2D/Heart5/full.visible = false
	elif Global. player_current_health == 75:
		$Node2D/Heart1/full1.visible = true
		$Node2D/Heart2/full2.visible = true
		$Node2D/Heart3/full.visible = true
		$Node2D/Heart4/full.visible = false
		$Node2D/Heart5/full.visible = false
	elif Global.player_current_health == 50:
		$Node2D/Heart1/full1.visible = true
		$Node2D/Heart2/full2.visible = true
		$Node2D/Heart3/full.visible = false
		$Node2D/Heart4/full.visible = false
		$Node2D/Heart5/full.visible = false
	elif Global.player_current_health == 25:
		$Node2D/Heart1/full1.visible = true
		$Node2D/Heart2/full2.visible = false
		$Node2D/Heart3/full.visible = false
		$Node2D/Heart4/full.visible = false
		$Node2D/Heart5/full.visible = false
	else:
		$Node2D/Heart1/full1.visible = false
		$Node2D/Heart2/full2.visible = false
		$Node2D/Heart3/full.visible = false
		$Node2D/Heart4/full.visible = false
		$Node2D/Heart5/full.visible = false
# adding heart when meeting 

func extra_heart():
	if Global.extra_heart == true:
		$Node2D/Heart5.visible = true
		active = true
	else:
		$Node2D/Heart5.visible = false
		active = false
