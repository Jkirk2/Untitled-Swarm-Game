extends Node2D
var cellWidth = 50
var cellHeight = 50
var rect = Rect2(Vector2(position.x - (cellWidth/2),position.y - (cellWidth/2)),Vector2(cellWidth,cellHeight))
var show = false
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Area2D/CollisionShape2D").shape.size.x = cellWidth
	get_node("Area2D/CollisionShape2D").shape.size.y = cellHeight


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw():
	if(show == true):
		draw_rect(rect,Color.DARK_ORANGE,true)

func _on_area_2d_mouse_entered():
	show = true
	queue_redraw()


func _on_area_2d_mouse_exited():
	show = false
	queue_redraw()
