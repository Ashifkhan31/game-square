extends CharacterBody2D

class_name player

var bullet_scene = preload("res://bullet/bullet.tscn")

var lives = 3
var speed: float = 235
var facing_direction: Vector2 = Vector2.DOWN

var movementState = idleState
var actionState = interactState

@onready var teleport_box = $teleport_box
@onready var interact_box = $interact_box

var bodies_in_teleport_area: Array
var reachable_items: Array
var reachable_interactables: Array
var held_item = null
var player_restrict = false

var shooting_bool = false
var teleport_bool = false 

var invincible = false
var invincible_timer: Timer

enum 
{
	idleState,
	walkingState,
	teleportingState
}

enum
{
	holdingState,
	shootingState,
	interactState,
	nullstate
}

func _ready() -> void:
	invincible_timer = Timer.new()
	invincible_timer.wait_time = 1
	invincible_timer.connect("timeout", end_invincibility)
	add_child(invincible_timer)

func get_damage():
	if not invincible:
		lives -= 1
		print("life left: ",lives)
		$AnimationPlayer.play("flash")
		invincible_timer.start()
		invincible = true

func end_invincibility():
	invincible = false

func _physics_process(delta: float) -> void:
	movement_FSM()
	action_FSM()
	move_and_slide()

func movement_FSM():
	match movementState:
		nullstate:
			if player_restrict == false:
				movementState = idleState
		idleState:
			
			#region state code
			velocity = Vector2.ZERO
			#endregion
			
			#region transition code
			if player_restrict == true:
				movementState = nullstate
			if Input.get_vector("left","right","up","down") != Vector2.ZERO:
					movementState = walkingState
			elif Input.is_action_just_pressed("teleport") and teleport_bool:
				movementState = teleportingState
			#endregion 
		
		walkingState:
			
			#region state code
			var input_direction = Input.get_vector("left","right","up","down")
			
			if  (
				input_direction == Vector2.RIGHT or 
				input_direction == Vector2.LEFT or
				input_direction == Vector2.UP or
				input_direction == Vector2.DOWN
			):
					facing_direction = input_direction
			
			turn_player(input_direction)
			
			velocity = input_direction * speed
			#endregion
			
			#region transition code
			if player_restrict == true:
				movementState = nullstate
			elif input_direction == Vector2.ZERO:
				movementState = idleState
			elif Input.is_action_just_pressed("teleport") and teleport_bool:
				movementState = teleportingState
			#endregion
		
		teleportingState:
			
			#region state code 
			if bodies_in_teleport_area.is_empty():
				global_position = teleport_box.get_child(0).global_position
			#endregion
			
			# transition code
			movementState = idleState

func action_FSM():
	match actionState:
		nullstate:
			if player_restrict == false:
				actionState = interactState
		interactState:
			# no state code
			
			#region transition code
			if Input.is_action_just_pressed("interact") and not reachable_items.is_empty():
				var item = reachable_items[0]
				item.reparent(interact_box)
				item.global_position = interact_box.get_child(0).global_position
				held_item = item
				actionState = holdingState
			elif Input.is_action_just_pressed("interact") and not reachable_interactables.is_empty():
				player_restrict = true
				reachable_interactables.pop_front().interact(self)
				actionState = nullstate
			elif Input.is_action_just_pressed("shoot") and shooting_bool:
				actionState = shootingState
			#endregion
		holdingState:
			#no state code
			
			#region transition code
			if Input.is_action_just_pressed("interact"):
				held_item.reparent(get_tree().root)
				held_item = null
				actionState = interactState
			#endregion
		shootingState:
			
			#region state code
			var instance = bullet_scene.instantiate()
			instance.dir = facing_direction
			instance.global_position = global_position
			get_tree().root.add_child(instance)
			#endregion
			
			# transition code 
			actionState = interactState


func turn_player(direction: Vector2):
	match direction:
		Vector2.RIGHT:
			teleport_box.transform = Transform2D(Vector2.UP,direction,teleport_box.position)
			interact_box.transform = Transform2D(Vector2.UP,direction,interact_box.position)
		Vector2.LEFT:
			teleport_box.transform = Transform2D(Vector2.UP,direction,teleport_box.position)
			interact_box.transform = Transform2D(Vector2.UP,direction,interact_box.position)
		Vector2.UP:
			teleport_box.transform = Transform2D(Vector2.LEFT,direction,teleport_box.position)
			interact_box.transform = Transform2D(Vector2.LEFT,direction,interact_box.position)
		Vector2.DOWN:
			teleport_box.transform = Transform2D(Vector2.LEFT,direction,teleport_box.position)
			interact_box.transform = Transform2D(Vector2.LEFT,direction,interact_box.position)


func _on_teleport_box_body_entered(body: Node2D) -> void:
	bodies_in_teleport_area.append(body)


func _on_teleport_box_body_exited(body: Node2D) -> void:
	bodies_in_teleport_area.erase(body)


func _on_interact_box_area_entered(area: Area2D) -> void:
	var area_script = area.get_script()
	if area_script != null: 
		if area_script.get_global_name() == "brick":
			reachable_items.append(area)
		elif "interactable" in area:
			reachable_interactables.append(area)


func _on_interact_box_area_exited(area: Area2D) -> void:
	reachable_items.erase(area)
	reachable_interactables.erase(area)
