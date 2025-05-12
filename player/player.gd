extends CharacterBody2D

@onready var teleport_box = $teleport_box
@onready var interact_box = $interact_box

var lives = 3
var speed = 235

var prev_dir: Vector2 = Vector2.UP

var bodies_in_teleport_area: Array

func _physics_process(delta):
	finite_state_machine()
	move_and_slide()

func finite_state_machine():
	var input_dir = Input.get_vector("left","right","up","down")

# ---MACHINE_1---
	if input_dir != Vector2.ZERO:
		prev_dir = input_dir
		velocity = speed * input_dir
		
		match input_dir:
			Vector2.RIGHT:
				teleport_box.transform = Transform2D(Vector2.UP,-input_dir,teleport_box.position)
				interact_box.transform = Transform2D(Vector2.UP,-input_dir,interact_box.position)
			Vector2.LEFT:
				teleport_box.transform = Transform2D(Vector2.UP,-input_dir,teleport_box.position)
				interact_box.transform = Transform2D(Vector2.UP,-input_dir,interact_box.position)
			Vector2.UP:
				teleport_box.transform = Transform2D(Vector2.LEFT,-input_dir,teleport_box.position)
				interact_box.transform = Transform2D(Vector2.LEFT,-input_dir,interact_box.position)
			Vector2.DOWN:
				teleport_box.transform = Transform2D(Vector2.LEFT,-input_dir,teleport_box.position)
				interact_box.transform = Transform2D(Vector2.LEFT,-input_dir,interact_box.position)
		
	
	if input_dir == Vector2.ZERO:
		velocity = Vector2.ZERO
	
#--MACHINE_2---
	if Input.is_action_just_pressed("interact"):
		pass
	
#---ETC---
	if Input.is_action_just_pressed("teleport"):
		if bodies_in_teleport_area.is_empty():
			global_position = teleport_box.get_child(0).global_position 

func _teleport_area_body_entered(body: Node2D) -> void:
	bodies_in_teleport_area.append(body)

func _teleport_area_body_exited(body: Node2D) -> void:
	bodies_in_teleport_area.erase(body)
