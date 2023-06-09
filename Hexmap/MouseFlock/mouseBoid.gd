extends Node2D

var otherBoids = []
var velocity = Vector2()
var turnfactor = 0.2
var visualRange = 50
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
var maxChecks = 10

func _ready():
	velocity = Vector2(randf_range(minspeed,maxspeed),randf_range(minspeed,maxspeed))
	position = Vector2(randf_range(0,get_viewport_rect().size.x),randf_range(0,get_viewport_rect().size.y))

	if(randf_range(0,100) > 50):
		scoutGroup = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	avg_pos = Vector2(0,0)
	avg_vel = Vector2(0,0)
	neighboring_boids = 0
	close_d = Vector2(0,0)
	getNeighbors()
	if neighboring_boids > 0:
		avg_pos = avg_pos/neighboring_boids
		avg_vel = avg_vel/neighboring_boids
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


func getNeighbors():
	
	if(get_node("Frontcheck").get_collider() != null):
		otherBoids.append(get_node("Frontcheck").get_collider())
	if(get_node("Leftcheck").get_collider() != null):
		otherBoids.append(get_node("Leftcheck").get_collider())
	if(get_node("RightCheck").get_collider() != null):
		otherBoids.append(get_node("RightCheck").get_collider())
	if(get_node("Frontleftcheck").get_collider() != null):
		otherBoids.append(get_node("Frontleftcheck").get_collider())
	if(get_node("Frontrightcheck").get_collider() != null):
		otherBoids.append(get_node("Frontrightcheck").get_collider())
		
	for Boid in otherBoids:
		Boid = Boid.get_parent()
		close_d = position - Boid.position
		avg_pos += Boid.position
		avg_vel += Boid.velocity
		neighboring_boids += 1
