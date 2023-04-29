extends Node2D
var obj = preload("res://Boid.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(100):
		add_child(obj.instantiate())
