extends Node2D


func _ready() -> void:
	Global.register_current_level(self)


func _process(_delta: float) -> void:
	pass
