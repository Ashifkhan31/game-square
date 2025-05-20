extends StaticBody2D

@export var and_buttons:Array[NodePath]
@export var or_buttons:Array[NodePath]

func _physics_process(delta: float) -> void:
	var and_bool_arr:Array[bool]
	var or_bool_arr:Array[bool]
	
	for i in and_buttons:
		var pressed = get_node(i).get("pressed")
		and_bool_arr.append(pressed)
	
	for i in or_buttons:
		var pressed = get_node(i).get("pressed")
		or_bool_arr.append(pressed)
	
	var and_buttons_bool = false if and_bool_arr.is_empty() else array_and(and_bool_arr)
	var or_buttons_bool = false if or_bool_arr.is_empty() else array_and(or_bool_arr)
	
	if and_buttons_bool or or_buttons_bool:
		gate_open()
	else:
		gate_close()

func gate_open():
	visible = false
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)

func gate_close():
	visible = true
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)

func array_and(arr: Array) -> bool:
	assert(not arr.is_empty())
	var res = true
	for i in arr:
		res = res and i
	return res

func array_or(arr: Array) -> bool:
	assert(not arr.is_empty())
	var res = false
	for i in arr:
		res = res or i
	return res
