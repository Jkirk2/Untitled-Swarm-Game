extends Node2D

var velocity = Vector2()
var turnfactor = 0.2
var protectedRange = 20
var centeringfactor = 0.0005
var avoidfactor = 0.02
var matchingfactor = 0.05
var maxspeed = 8
var minspeed = 3
var maxbias = 0.01
var bias_increment = 0.00004
var biasval = .001
var margin = 200
var scoutGroup = false
var avg_pos = Vector2(0,0)
var avg_vel = Vector2(0,0)
var neighboring_boids = 0
var close_d = Vector2(0,0)
var nearby_boids = []


func _ready():

	velocity = Vector2(randf_range(minspeed,maxspeed),randf_range(minspeed,maxspeed))
	position = Vector2(randf_range(0,get_viewport_rect().size.x),randf_range(0,get_viewport_rect().size.y))

	if(randf_range(0,100) > 50):
		scoutGroup = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	close_d = Vector2(0,0)
	if(nearby_boids.size() >0):
		var distance = 999
		var nearest_boid_pos = Vector2(0,0)
		for boid in nearby_boids:
			if(position.distance_squared_to(boid.position) < distance):
				nearest_boid_pos = boid.position
		close_d = position - nearest_boid_pos
	
	velocity = (velocity + (avg_pos - position)*centeringfactor + (avg_vel - velocity)*matchingfactor)
	velocity = velocity + (close_d * avoidfactor)
	
	if position.y < margin:
		velocity.y += turnfactor
	if position.x < margin:
		velocity.x += turnfactor
	if position.y > get_viewport_rect().size.y - margin:
		velocity.y -= turnfactor
	if position.x > get_viewport_rect().size.x - margin:
		velocity.x -= turnfactor
	
	if(scoutGroup):
		velocity.x = (1 - biasval)*velocity.x + (biasval * 1)
	else:
		velocity.x = (1 - biasval)*velocity.x + (biasval * -1)
		
	var speed = velocity.length()
	if speed < minspeed:
		velocity = velocity.normalized() * minspeed
	if speed > maxspeed:
		velocity = velocity.normalized() * maxspeed
	position += velocity * (60*delta)
	rotation = (velocity.angle() + PI/2)

func set_averages(average_position, average_velocity):
	avg_pos = average_position
	avg_vel = average_velocity
	



func _on_area_2d_body_entered(obj):
	nearby_boids.append(obj)


func _on_area_2d_body_exited(obj):
	nearby_boids.erase(obj.get_parent)
