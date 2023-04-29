extends Node2D

var boids = []
var num_of_boids = 0
# Called when the node enters the scene tree for the first time.
var avg_pos = Vector2(0,0)
var avg_vel = Vector2(0,0)

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	num_of_boids = boids.size()
	for boid in boids:
		avg_pos += boid.position
		avg_vel += boid.velocity
	avg_pos = avg_pos/num_of_boids
	avg_vel = avg_vel/num_of_boids
	
	for boid in boids:
		boid.set_averages(avg_pos,avg_vel)
	
	

func _on_collision_shape_2d_tree_entered(obj):
	boids.append(obj.get_parent())
	


func _on_collision_shape_2d_tree_exited(obj):
	boids.erase(obj.get_parent())
