extends Node2D

var boids = []
var avg_pos = Vector2(0,0)
var avg_vel = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_averages()


func get_averages():
	if(boids.size() > 0):
		for boid in boids:
			avg_pos += boid.position
			avg_vel += boid.velocity
		avg_pos = avg_pos/boids.size()
		avg_vel = avg_vel/boids.size()
		for boid in boids:
			boid.avg_pos = avg_pos
			boid.avg_vel = avg_vel
			boid.neighboring_boids = boids.size()



func _on_area_2d_body_entered(boid):
	boids.append(boid)


func _on_area_2d_body_exited(boid):
	boids.append(boid)
