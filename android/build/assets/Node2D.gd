extends CharacterBody2D

const MAX_SPEED = 100.0
const MAX_FORCE = 50.0


var acceleration := Vector2.ZERO

func _physics_process(delta: float) -> void:
	var nearby_boids = get_overlapping_areas()
	var separation = separate(nearby_boids)
	var alignment = align(nearby_boids)
	var cohesion = cohere(nearby_boids)

	separation = separation * 1.5
	alignment = alignment * 1.0
	cohesion = cohesion * 1.0

	acceleration = separation + alignment + cohesion
	acceleration = limit_force(acceleration, MAX_FORCE)

	velocity = velocity + acceleration * delta
	velocity = limit_speed(velocity, MAX_SPEED)

	position = position + velocity * delta
	wrap_around()

func separate(boids: Array) -> Vector2:
	var sum = Vector2.ZERO
	var count = 0
	for boid in boids:
		var distance = position.distance_to(boid.position)
		if distance > 0 and distance < 50.0:
			var diff = position - boid.position
			diff = diff.normalized()
			diff = diff / distance
			sum = sum + diff
			count += 1

	if count > 0:
		sum = sum / count

	if sum.length_squared() > 0:
		sum = sum.normalized()
		sum = sum * MAX_SPEED
		sum = sum - velocity
		sum = limit_force(sum, MAX_FORCE)

	return sum

func align(boids: Array) -> Vector2:
	var sum = Vector2.ZERO
	var count = 0
	for boid in boids:
		var distance = position.distance_to(boid.position)
		if distance > 0 and distance < 50.0:
			sum = sum + boid.velocity
			count += 1

	if count > 0:
		sum = sum / count

	if sum.length_squared() > 0:
		sum = sum.normalized()
		sum = sum * MAX_SPEED
		sum = sum - velocity
		sum = limit_force(sum, MAX_FORCE)

	return sum

func cohere(boids: Array) -> Vector2:
	var sum = Vector2.ZERO
	var count = 0
	for boid in boids:
		var distance = position.distance_to(boid.position)
		if distance > 0 and distance < 50.0:
			sum = sum + boid.position
			count += 1

	if count > 0:
		sum = sum / count
		var desired = sum - position
		desired = desired.normalized()
		desired = desired * MAX_SPEED
		var steer = desired - velocity
		steer = limit_force(steer, MAX_FORCE)

		return steer

	return sum







