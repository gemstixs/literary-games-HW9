extends CharacterBody2D # this code is applied to CharacterBody2D
var gravity : Vector2 # gravity is defined by a specific vector shape, with coordinates listed as (x,y)
@export var jump_height : float ## How high should they jump?
@export var movement_speed : float ## How fast can they move?
@export var horizontal_air_coefficient : float ## Should the player move more slowly left and right in the air? Set to zero for no movement, 1 for the same
@export var speed_limit : float ## What is the player's max speed? 
@export var friction : float ## What friction should they experience on the ground?

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity = Vector2(0, 100)
	pass # Replace with function body.


func _get_input(): # getting the input (duh) from the player and calculating what to do with that input
	if is_on_floor(): # checking if the character is on the floor; if true then...
		if Input.is_action_pressed("move_left"): # checks the input map for an action (key) connected to moving left being activated
			velocity += Vector2(-movement_speed,0) # moves character by directly changing the character's velocity, indicates direction of movement with coordinates, in this case going toward negative numbers on the x axis to go left 

		if Input.is_action_pressed("move_right"): # checks the input map for an action (key) connected to moving right being activated
			velocity += Vector2(movement_speed,0) # moves character by directly changing the character's velocity, indicates direction of movement with coordinates, in this case going toward positive numbers on the x axis to go right

		if Input.is_action_just_pressed("jump"): # Jump only happens when we're on the floor (unless we want a double jump, but we won't use that here)
			velocity += Vector2(0,-jump_height) # moves character by directly changing the character's velocity, indicates direction of movement with coordinates, in this case going toward negative numbers on the y axis to go up

	if not is_on_floor(): # checking if the character is NOT on the floor; if true then
		if Input.is_action_pressed("move_left"): # checks the input map for an action (key) connected to moving left being activated
			velocity += Vector2(-movement_speed * horizontal_air_coefficient,0) # moves character by directly changing the character's velocity, indicates direction of movement with coordinates, in this case going toward negative numbers on the x axis to go left while calculating for the set horizontal air coefficient

		if Input.is_action_pressed("move_right"): # checks the input map for an action (key) connected to moving right being activated
			velocity += Vector2(movement_speed * horizontal_air_coefficient,0) # moves character by directly changing the character's velocity, indicates direction of movement with coordinates, in this case going toward positive numbers on the x axis to go right while calculating for the set horizontal air coefficient

func _limit_speed(): # speed limit says if our character is going faster than the speed limit in a given direction, set the character to the speed limit of the opposite direction 
	if velocity.x > speed_limit: # if velocity on x axis is greater than the speed limit, then...
		velocity = Vector2(speed_limit, velocity.y) # the velocity is set to the speed limit of the y axis

	if velocity.x < -speed_limit: # inverse of above
		velocity = Vector2(-speed_limit, velocity.y) # inverse of above

func _apply_friction(): # character will slow down on the floor when player is not moving it
	if is_on_floor() and not (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")): # the floor applies friction to the character when action isn't being applied
		velocity -= Vector2(velocity.x * friction, 0) # velocity will decrease by this amount of friction
		if abs(velocity.x) < 5: # if velocity is less than 5...
			velocity = Vector2(0, velocity.y) # set it to zero, bringing character to complete stop

func _apply_gravity(): # how is gravity applied to this character?
	if not is_on_floor(): # when the character is in the air...
		velocity += gravity # gravity will be applied!

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_get_input() # getting player input
	_limit_speed() # calculating speed limits
	_apply_friction() # adding friction!
	_apply_gravity() # if not on the floor, add gravity

	move_and_slide() # applies set velocity to the character (this is pre-set by Godot)
	pass
