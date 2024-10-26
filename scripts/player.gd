extends CharacterBody2D

@export var speed = 300 #this variables are declared with export to change the values in the inspector section of the godot editor
@export var gravity = 30
@export var jump_force = 700

@onready var animation_player = $AnimationPlayer #connecting or calling the respective nodes to the variables
@onready var sprite = $Sprite2D

func _physics_process(_delta):
	
	if !is_on_floor(): #checking if the player is on floor or not
		velocity.y += gravity#if not on floor the gravity is incremented till 1000
		if velocity.y > 1000:
			velocity.y = 1000
			
	if Input.is_action_just_pressed("jump"): #&& is_on_floor(): #this allow the user to press space bar to make the player jump
		velocity.y = -jump_force
		
	var horizontal_direction = Input.get_axis("move_left","move_right") #control the player movement horizontaly(left,right)
	velocity.x = speed * horizontal_direction 
	move_and_slide()
	update_animantions(horizontal_direction)
	
	if horizontal_direction != 0:#if the diredtion is not zero or the player is idle the function will be called
		switch_direction(horizontal_direction) 
		
func update_animantions(horizontal_direction): #this function updated animation according to the action of the player
	if is_on_floor():
		if horizontal_direction == 0: #if not movement or idle the animation will play "idle"
			animation_player.play("idle")
		else: #else play run animation 
			animation_player.play("run")
	else: #checks the y axis velocity for playing jumping and runnging animation 
		if velocity.y < 0: #if y is less than zero jump animation is played (in godot the y becomes negative when going up)
			animation_player.play("jump")
		elif velocity.y > 0: # if y is greater than zero fall animation is played
			animation_player.play("fall")
		
func switch_direction(horizontal_direction): #this function flips the sprite horizontally to match the movement animation (facing the player right when running right and vice versa)
	sprite.flip_h = (horizontal_direction ==-1)
	sprite.position.x = horizontal_direction * 3.6
	
	print(velocity) #prints the velocity for debugging purposes
