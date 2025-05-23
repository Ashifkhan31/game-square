extends CharacterBody2D

class_name player

@onready var teleport_box = $teleport_box
@onready var interact_box = $interact_box

var bullet_scene = preload("res://bullet/bullet.tscn")
var invincible = false
var invincible_timer: Timer
var lives = 3
var speed = 235
var prev_dir: Vector2 = Vector2.UP
var fourway_prev_dir: Vector2 = Vector2.UP
var holding = false
var reachable_items: Array
var held_item
var bodies_in_teleport_area: Array

func _ready() -> void:
	invincible_timer = Timer.new()
	invincible_timer.wait_time = 0.8
	invincible_timer.connect("timeout", end_invincibility)
	add_child(invincible_timer)

func _physics_process(delta):
	finite_state_machine()
	move_and_slide()

func finite_state_machine():
	var input_dir = Input.get_vector("left","right","up","down")

# ---MACHINE_1---
	if input_dir != Vector2.ZERO:
		prev_dir = input_dir
		velocity = speed * input_dir
	
	if prev_dir == Vector2.RIGHT or prev_dir == Vector2.LEFT or prev_dir == Vector2.UP or prev_dir == Vector2.DOWN:
		fourway_prev_dir = prev_dir
	
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
	var holdable_item = find_a_holdable()
	var interact = Input.is_action_just_pressed("interact")
	var can_hold_item = interact and not holding and (holdable_item != null)
	
	if can_hold_item or (holding and not interact):
		if not holding:
			holding = true
			holdable_item.reparent(interact_box)
			holdable_item.global_position = interact_box.get_child(0).global_position
			held_item = holdable_item
			interact = false
	if interact and holding:
		holding = false
		held_item.reparent(get_tree().root)
	
	if Input.is_action_just_pressed("shoot") and not holding:
		var instance = bullet_scene.instantiate()
		instance.dir = fourway_prev_dir
		instance.global_position = global_position
		get_tree().root.add_child(instance)
		
#---ETC---
	if Input.is_action_just_pressed("teleport"):
		if bodies_in_teleport_area.is_empty():
			global_position = teleport_box.get_child(0).global_position 

func get_damage():
	if not invincible:
		lives -= 1
		print("life left: ",lives)
		$AnimationPlayer.play("flash")
		invincible_timer.start()
		invincible = true

func end_invincibility():
	invincible = false

func find_a_holdable():
	for body in reachable_items:
		if body != null:
			var body_script = body.get_script()
			if body_script != null: 
				if body_script.get_global_name() == "brick":
					return body
	return null


func _on_interact_box_area_entered(area: Area2D) -> void:
		reachable_items.append(area)

func _on_interact_box_area_exited(area: Area2D) -> void:
		reachable_items.erase(area)

func _teleport_area_body_entered(body: Node2D) -> void:
	bodies_in_teleport_area.append(body)

func _teleport_area_body_exited(body: Node2D) -> void:
	bodies_in_teleport_area.erase(body)
